TOREE_VERSION := 9b577f19df83dab95419b781de710ea2a393202a
SHA := $(shell echo ${TOREE_VERSION} | sed 's,\(.......\).*,\1,')
BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := $(word 1, ${BASE})
REPO := $(word 2, ${BASE})-$(word 3, ${BASE})
IMG  := quay.io/${ORG}/${REPO}


.PHONY all: build

archives/${TOREE_VERSION}.zip:
	(cd archives ; curl -L -C - -O "https://github.com/apache/incubator-toree/archive/${TOREE_VERSION}.zip")

spark-2.0.2-bin-hadoop2.7.tgz:
	curl -L -C - -O "http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz"

incubator-toree-${TOREE_VERSION}: archives/${TOREE_VERSION}.zip
	rm -rf $@
	unzip $<

incubator-toree-${TOREE_VERSION}/dist/toree-pip/toree-0.2.0.dev1.tar.gz: incubator-toree-${TOREE_VERSION}
	make -C $< release

toree-0.2.0.dev1.tar.gz: incubator-toree-${TOREE_VERSION}/dist/toree-pip/toree-0.2.0.dev1.tar.gz
	cp $< $@

.PHONY build: toree-0.2.0.dev1.tar.gz spark-2.0.2-bin-hadoop2.7.tgz
	docker build -t ${IMG}:${SHA} .

.PHONY publish: build
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
