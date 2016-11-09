BASE := $(subst -, ,$(notdir ${CURDIR}))
ORG  := $(word 1, ${BASE})
REPO := $(word 2, ${BASE})-$(word 3, ${BASE})
IMG  := quay.io/${ORG}/${REPO}

build:
	docker build -t ${IMG}:latest	.

publish: build
	docker push ${IMG}:latest
	if [ "${TAG}" != "" -a "${TAG}" != "latest" ]; then docker tag ${IMG}:latest ${IMG}:${TAG} && docker push ${IMG}:${TAG}; fi

# test: build
# 	docker-compose up -d
# 	docker-compose run --rm hdfs-name bash -c "set -e \
# 		&& source /sbin/hdfs-lib.sh \
# 		&& wait_until_hdfs_is_available \
# 		&& hdfs dfs -touchz /live-check \
# 		&& hdfs dfs -ls /live-check"
# 	docker-compose down
