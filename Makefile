VERSION := 4
SPARK_VERSION := 2.1.0-bin-hadoop2.7
BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geodocker
REPO := jupyter
IMG  := quay.io/${ORG}/${REPO}


.PHONY all: build

spark-${SPARK_VERSION}.tgz:
	curl -L -O "http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}.tgz"

build: spark-${SPARK_VERSION}.tgz
	docker build --build-arg SPARK_VERSION=${SPARK_VERSION} -t ${IMG}:${VERSION} .

run:
	docker run --rm -it --name jupyter -p 8000:8000 -v $(CURDIR)/notebooks:/opt/notebooks ${IMG}:${VERSION} ${CMD}

exec:
	docker exec -it -u root jupyter bash

reset:
	docker kill jupyter
	docker rm jupyter

publish: build
	docker push ${IMG}:${VERSION}
	docker tag ${IMG}:${VERSION} ${IMG}:latest
	if [ "${TAG}" != "" -a "${TAG}" != "${VERSION}" ]; then docker tag ${IMG}:${VERSION} ${IMG}:${TAG} && docker push ${IMG}:${TAG} && docker push ${IMG}:latest; fi

test: build
