DOCKER = docker
VUE_SRC = $(shell find public src)
WEBOS_SRC = $(shell find app)
DIST = $(shell find dist)
TV=livingroom
EMU=emulator
APP=tv.cesium.app


$(WEBOS_SRC):


sysdeps:
	npm install -g @webosose/ares-cli


dist:
	mkdir dist


dist/${APP}_0.0.1_all.ipk: dist $(WEBOS_SRC)
	ares-package app -o dist/


build: dist/${APP}_0.0.1_all.ipk
	$(MAKE) -C web build


image: build
	${DOCKER} build -t web:latest -f docker/web/Dockerfile .


.PHONY: dev
dev: node_modules
	npm run dev


.PHONY: run
run: image install-tv
	ares-launch --device=${TV} ${APP}
	${DOCKER} run -ti --net=host web:latest


.PHONY: install-tv
install-tv: build
	ares-install --device=${TV} dist/${APP}_0.0.1_all.ipk


.PHONY: install-emu
install-emu: build
	ares-install --device=${EMU} dist/${APP}_0.0.1_all.ipk


.PHONY: emu
emu: image install-emu
	ares-launch --device=${EMU} ${APP}
	${DOCKER} run -ti --net=host web:latest


.PHONY: debug
debug:
	ares-inspect --device=${TV} ${APP}


.PHONY: debug-emu
debug-emu:
	ares-inspect --device=${EMU} ${APP}


.PHONY: clean
clean:
	rm -rf dist
	$(MAKE) -C web clean
