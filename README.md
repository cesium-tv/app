# cesium

WebOS video player

This application is for LG webOS TVs. It is written using Vue+Buefy to provide a modern UI for watching video on your television.

At this time, the application is in development, so it is not easy to install or use. In the future, I may try to get it added to the LG content store.

## development

Pull requests are welcome.

This application depends heavily on a library called `errokees` which handles keyboard navigation, which is needed to make the TV remote function https://github.com/btimby/errokees/.

If you need to modify how the keyboard handling is done, look there.

To develop on Cesium itself, work out of the watch repository:

https://github.com/cesium-tv/watch/

Two versions of this app can be built, bundled or hosted.

 - *hosted* simply loads https://watch.cesium.tv/ within the app window.
 - *bundled* builds the web app and packages it to run on the TV.

The hosted version is much smaller and generally preferred. The bundled version however may be more suitable for some situations. Both are presented here as an example.

### emulator / SDK

Following the instructions below to install the SDK and emulator. Note that virtualbox is necessary, so go ahead and install the first.

https://webostv.developer.lge.com/sdk/command-line-interface/installation/#
https://webostv.developer.lge.com/sdk/tools/emulator/installation/

```bash
$ make install-emu
$ make emu
```

### TV setup

On your TV, install the Developer app from LG content store. Sign up for an account with LG, see the instructions below.

https://webostv.developer.lge.com/develop/app-test/using-devmode-app/

Once you have an account, you can use the app to log into your account and enable development mode. Once that is done, you can use the `Makefile` to deploy, test and debug the app. Developer mode expires every two weeks (I think) and can be extended using ares.

```bash
$ make install-tv
$ make run
```
