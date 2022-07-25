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
	touch node_modules


dist:
	mkdir dist


dist/index.html: $(VUE_SRC)
	npm run build
	touch dist/index.html


dist/${APP}_0.0.1_all.ipk: dist $(WEBOS_SRC)
	ares-package app -o dist/


build: node_modules dist/index.html dist/${APP}_0.0.1_all.ipk


image: build
	${DOCKER} build -t cesium.tv-web:latest -f docker/cesium.tv-web/Dockerfile .


.PHONY: dev
dev: node_modules
	npm run dev


.PHONY: run
run: image install-tv
	ares-launch --device=${TV} ${APP}
	${DOCKER} run -ti --net=host cesium.tv-web:latest


.PHONY: install-tv
install-tv: build
	ares-install --device=${TV} dist/${APP}_0.0.1_all.ipk


.PHONY: install-emu
install-emu: build
	ares-install --device=${EMU} dist/${APP}_0.0.1_all.ipk


.PHONY: emu
emu: image install-emu
	ares-launch --device=${EMU} ${APP}
	${DOCKER} run -ti --net=host cesium.tv-web:latest


.PHONY: debug
debug:
	ares-inspect --device=${TV} ${APP}


.PHONY: debug-emu
debug-emu:
	ares-inspect --device=${EMU} ${APP}


.PHONY: clean
clean:
	rm -rf dist node_modules
