DOCKER = docker
VUE_SRC = $(shell find public src)
DIST = $(shell find dist)
TV=livingroom
EMU=emulator
HOSTED=tv.cesium.hosted
BUNDLED=tv.cesium.bundled
ASSETS=$(find assets)
APP=tv.cesium.watch


all:
	echo "Two build flavors\nex: make bundled or make hosted"


sysdeps:
	npm install -g @webosose/ares-cli


dist:
	mkdir -p dist


.work:
	mkdir -p .work


.PHONY: watch
watch:
	make -C watch build
	cp -f watch/dist/index.html .work/index.html
	cp -fR watch/dist/assets .work/assets 


dist/${APP}_0.0.1_all.ipk: dist
	ares-package .work -n -o dist/


app: dist/tv.cesium.watch_0.0.1_all.ipk


assets: .work $(ASSETS)
	cp -R assets/* .work


.PHONY: hosted
hosted: assets
	make app


.PHONY: bundled
bundled: assets watch
	make app


.PHONY: run
run: image install-tv
	ares-launch --device=${TV} ${APP}


.PHONY: install-tv
install-tv: build
	ares-install --device=${TV} dist/${APP}_0.0.1_all.ipk


.PHONY: install-emu
install-emu: build
	ares-install --device=${EMU} dist/${APP}_0.0.1_all.ipk


.PHONY: emu
emu: image install-emu
	ares-launch --device=${EMU} ${APP}


.PHONY: debug
debug:
	ares-inspect --device=${TV} --open ${APP}


.PHONY: debug-emu
debug-emu:
	ares-inspect --device=${EMU} --open ${APP}


.PHONY: update
update:
	git submodule update --remote


.PHONY: clean
clean:
	rm -rf dist .work
	make -C watch clean

