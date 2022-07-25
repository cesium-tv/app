DOCKER = docker
VUE_SRC = $(shell find public src)
WEBOS_SRC = $(shell find app)
DIST = $(shell find dist)
TV=livingroom
EMU=emulator
APP=tv.cesium.app


$(WEBOS_SRC):


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


.PHONY: runs
run: image
	${DOCKER} run -ti --net=host cesium.tv-web:latest


dist:
	mkdir dist


dist/${APP}_0.0.1_all.ipk: dist $(WEBOS_SRC)
	ares-package app -o dist/


build: dist/${APP}_0.0.1_all.ipk


.PHONY: install-tv
install-tv: build
	ares-install --device=${TV} dist/${APP}_0.0.1_all.ipk


.PHONY: install-emu
install-emu: build
	ares-install --device=${EMU} dist/${APP}_0.0.1_all.ipk


.PHONY: run
run: install-tv
	ares-launch --device=${TV} ${APP}


.PHONY: emu
emu: install-emu
	ares-launch --device=${EMU} ${APP}


.PHONY: debug
debug:
	ares-inspect --device=${TV} ${APP}


.PHONY: debug-emu
debug-emu:
	ares-inspect --device=${EMU} ${APP}


.PHONY: clean
clean:
	rm -rf dist node_modules
