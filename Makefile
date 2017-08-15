TAG ?= 5
SPARK_VERSION := 2.1.0-bin-hadoop2.7
BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := geodocker
REPO := jupyter
IMG  := quay.io/${ORG}/${REPO}


.PHONY all: build

archives/spark-${SPARK_VERSION}.tgz:
	(cd archives ; curl -L -O "http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}.tgz")

archives/629ac54cae9767310616d47d769665453619ac64.zip:
	(cd archives ; curl -L -O "https://github.com/ipython/ipykernel/archive/629ac54cae9767310616d47d769665453619ac64.zip")

archives/ipykernel.tar: archives/629ac54cae9767310616d47d769665453619ac64.zip
	(cd archives ; unzip 629ac54cae9767310616d47d769665453619ac64.zip ; mv ipykernel-629ac54cae9767310616d47d769665453619ac64 ipykernel ; tar cvf ipykernel.tar ipykernel/ ; rm -rf ipykernel/)

build: archives/ipykernel.tar archives/spark-${SPARK_VERSION}.tgz
	docker build --build-arg SPARK_VERSION=${SPARK_VERSION} -t ${IMG}:${TAG} .

run:
	docker run --rm -it \
           --name jupyter \
           -p 8000:8000 \
           -v $(CURDIR)/notebooks:/opt/notebooks \
           $(IMG):$(TAG) $(CMD)

exec:
	docker exec -it -u root jupyter bash

reset:
	docker kill jupyter
	docker rm jupyter

publish: build
	docker tag "$(IMG):$(TAG)" "$(IMGf):latest"
	docker push "$(IMG):$(TAG)"
	docker push "$(IMG):latest"

test: build
