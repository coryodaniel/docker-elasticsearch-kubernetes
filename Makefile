.PHONY: build run release url clean shell

REGISTRY 	  := quay.io
IMAGE_NAME  := coryodaniel/elasticsearch-kubernetes
IMAGE_URL  := ${REGISTRY}/${IMAGE_NAME}
TEST_PREFIX := es-k8s-dbg

all: clean build run

url:
	@echo ${IMAGE_URL}

build:
	docker build -t ${IMAGE_NAME} .

release: REL_TIME=$(shell date +%s)
release:
	docker tag ${IMAGE_NAME} ${IMAGE_URL}:latest && \
	docker tag ${IMAGE_NAME} ${IMAGE_URL}:${REL_TIME} && \
	docker push ${IMAGE_URL}:latest && \
	docker push ${IMAGE_URL}:${REL_TIME}

shell:
	docker run --name ${TEST_PREFIX}-shell -it ${IMAGE_NAME}:latest /bin/bash

tmp:
	mkdir -p ./tmp

clean:
	rm -rf ./tmp
	docker ps --format "{{.Names}}" -a | grep "${TEST_PREFIX}" | xargs docker rm

run: tmp
run:
	docker run --name ${TEST_PREFIX} --privileged \
		--volume tmp:/data \
		--publish-all \
		${IMAGE_NAME}:latest
