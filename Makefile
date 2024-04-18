PLATFORMS ?= linux/amd64,linux/arm64
GOOS ?= linux
GOARCH ?= amd64
DOCKER := docker
IMAGE := quay.io/fgiorgetti/skupper-redirect

all:
	${DOCKER} buildx create --name skupper --use --bootstrap
	${DOCKER} buildx prune -af
	${DOCKER} buildx build --platform ${PLATFORMS} -t ${IMAGE} .
	${DOCKER} buildx build --load  -t ${IMAGE} .
	${DOCKER} buildx build --push --platform ${PLATFORMS} -t ${IMAGE} .
