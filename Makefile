TOREE_VERSION := 9b577f19df83dab95419b781de710ea2a393202a
SPARK_VERSION := 2.1.0-bin-hadoop2.7
SHA := $(shell echo ${TOREE_VERSION} | sed 's,\(.......\).*,\1,')
BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geodocker
REPO := jupyter
IMG  := quay.io/${ORG}/${REPO}


.PHONY all: build

archives/${TOREE_VERSION}.zip:
	(cd archives ; curl -L -O "https://github.com/apache/incubator-toree/archive/${TOREE_VERSION}.zip")

spark-${SPARK_VERSION}.tgz:
	curl -L -O "http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}.tgz"

incubator-toree-${TOREE_VERSION}: archives/${TOREE_VERSION}.zip
	rm -rf $@
	unzip $<

incubator-toree-${TOREE_VERSION}/dist/toree-pip/toree-0.2.0.dev1.tar.gz: incubator-toree-${TOREE_VERSION}
	make -C $< release

toree-0.2.0.dev1.tar.gz: incubator-toree-${TOREE_VERSION}/dist/toree-pip/toree-0.2.0.dev1.tar.gz
	cp $< $@

build: toree-0.2.0.dev1.tar.gz spark-2.1.0-bin-hadoop2.7.tgz
	docker build -t ${IMG}:latest .

run:
	docker run --rm --name jupyter  -it -p 8000:8000 -v $(CURDIR)/notebooks:/opt/notebooks ${IMG}:latest ${CMD}

exec:
	docker exec -it -u root jupyter bash

reset:
	docker kill jupyter
	docker rm jupyter

publish: build
	docker push ${IMG}:${SHA}
	if [ "${TAG}" != "" -a "${TAG}" != "${SHA}" ]; then docker tag ${IMG}:${SHA} ${IMG}:${TAG} && docker push ${IMG}:${TAG}; fi

test: build
