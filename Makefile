DOCKER = docker
VUE_SRC = $(shell find public src)
DIST = $(shell find dist)
TV=livingroom
EMU=emulator
HOSTED=tv.cesium.hosted
HOSTED_SRC = $(shell find ${HOSTED})
BUNDLED=tv.cesium.bundled
WATCH_SRC = $(shell find watch)


$(HOSTED_SRC):


sysdeps:
	npm install -g @webosose/ares-cli


dist:
	mkdir dist

watch:
	make -C watch build
	cp watch/dist/index.html ${BUNDLED}/index.html
	cp -R watch/dist/assets ${BUNDLED}/assets 


dist/${HOSTED}_0.0.1_all.ipk: dist $(HOSTED_SRC)
	ares-package ${HOSTED} -o dist/


$(BUNDLED)/index.html: watch


dist/${BUNDLED}_0.0.1_all.ipk: dist ${BUNDLED}/index.html
	ares-package ${BUNDLED} -n -o dist/


hosted: dist/${HOSTED}_0.0.1_all.ipk


bundled: dist/${BUNDLED}_0.0.1_all.ipk


.PHONY: run
run: image install-tv
	ares-launch --device=${TV} ${HOSTED}


.PHONY: install-tv
install-tv: build
	ares-install --device=${TV} dist/${HOSTED}_0.0.1_all.ipk


.PHONY: install-emu
install-emu: build
	ares-install --device=${EMU} dist/${HOSTED}_0.0.1_all.ipk


.PHONY: emu
emu: image install-emu
	ares-launch --device=${EMU} ${HOSTED}


.PHONY: debug
debug:
	ares-inspect --device=${TV} --open ${HOSTED}


.PHONY: debug-emu
debug-emu:
	ares-inspect --device=${EMU} --open ${HOSTED}


.PHONY: clean
clean:
	rm -rf dist
	make -C watch clean
