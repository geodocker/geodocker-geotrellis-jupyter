TOREE_VERSION := 9b577f19df83dab95419b781de710ea2a393202a
SHA := $(shell echo ${TOREE_VERSION} | sed 's,\(.......\).*,\1,')
BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := $(word 1, ${BASE})
REPO := $(word 2, ${BASE})-$(word 3, ${BASE})
IMG  := quay.io/${ORG}/${REPO}


.PHONY all: build

archives/${TOREE_VERSION}.zip:
	(cd archives ; curl -L -O "https://github.com/apache/incubator-toree/archive/${TOREE_VERSION}.zip")

spark-2.1.0-bin-hadoop2.7.tgz:
	curl -L -O "http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz"

incubator-toree-${TOREE_VERSION}: archives/${TOREE_VERSION}.zip
	rm -rf $@
	unzip $<

incubator-toree-${TOREE_VERSION}/dist/toree-pip/toree-0.2.0.dev1.tar.gz: incubator-toree-${TOREE_VERSION}
	make -C $< release

toree-0.2.0.dev1.tar.gz: incubator-toree-${TOREE_VERSION}/dist/toree-pip/toree-0.2.0.dev1.tar.gz
	cp $< $@

geotrellis-uberjar-assembly-1.0.0-RC1.jar: geotrellis-uberjar/build.sbt
	(cd geotrellis-uberjar ; ./sbt "assembly")
	cp geotrellis-uberjar/target/scala-2.11/geotrellis-uberjar-assembly-1.0.0-RC1.jar $@

build: toree-0.2.0.dev1.tar.gz spark-2.1.0-bin-hadoop2.7.tgz geotrellis-uberjar-assembly-1.0.0-RC1.jar
	docker build --no-cache -t ${IMG}:${SHA} .

run:
	docker run -it -v $(CURDIR)/notebooks:/opt/notebooks -p 8000:8000 quay.io/geodocker/geotrellis-jupyter:9b577f1

publish: build
	docker push ${IMG}:${SHA}
	if [ "${TAG}" != "" -a "${TAG}" != "${SHA}" ]; then docker tag ${IMG}:${SHA} ${IMG}:${TAG} && docker push ${IMG}:${TAG}; fi

# test: build
# 	docker-compose up -d
# 	docker-compose run --rm hdfs-name bash -c "set -e \
# # 		&& source /sbin/hdfs-lib.sh \
# # 		&& wait_until_hdfs_is_available \
# # 		&& hdfs dfs -touchz /live-check \
# # 		&& hdfs dfs -ls /live-check"
# 	docker-compose down
