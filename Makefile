DOCKER = docker
VUE_SRC = $(shell find public src)
DIST = $(shell find dist)


node_modules: package-lock.json
	npm i


dist/index.html: $(VUE_SRC)
	npm run build
	touch dist/index.html


build: node_modules dist/index.html


image: build
	${DOCKER} build -t cesium.tv-web:latest -f docker/cesium.tv-web/Dockerfile .


.PHONY: dev
dev: node_modules
	npm run dev


.PHONY: run
run: image
	${DOCKER} run -ti --net=host cesium.tv-web:latest


clean:
	rm -rf dist node_modules
