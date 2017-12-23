## Cordova

* [Cordova docs](https://cordova.apache.org/docs/)

## Android Studio

Start Studio

    /opt/android-studio/bin/studio.sh

Configure Emulator

If you do not need sound in your emulator you can disable it by editing  ~/.android/avd/<AVD_Name>.avd/config.ini

    hw.audioInput=no
    hw.audioOutput=no

Start Emulator

    ~/Android/Sdk/emulator/emulator  -list-avds
    ~/Android/Sdk/emulator/emulator  @Nexus_5X_API_26_x86


Inspect via Chrome

In the locationbar `chrome://inspect/#devices`

## Build

If errors:

    cordova build --verbose android

## ADB

Start latest version `adb`

    ~/Android/Sdk/platform-tools/adb
* Prepare you Android devices
 * Enable developer mode in android settings
 * Enable debug by usb
 * Plug your device to the computer by usb

Some usefull commands

    adb shell content query --uri content://settings/system
    adb shell content query --uri content://settings/secure --where "name=\'android_id\'"

Debug with adb

    adb logcat | grep -i "name.ofyour.app"

## Notifications

    cordova create simplepush com.singlepush.app
    cd simplepush
    cordova platform add android@6.3.0
    cordova plugin add cordova-plugin-firebase@0.1.25 --save


* Goto [Firebase console](https://console.firebase.google.com/) -> select/create your project
* Give the package name the same as `widget id` in `config.xml` in your cordova project.
* Download `google-services.json` to the root of you project.

Resources:

* [Simple Push Notification Firebase Cordova Plugin](https://www.youtube.com/watch?v=DvRGNrGpI_A)
* [FCM + postman](https://medium.com/android-school/test-fcm-notification-with-postman-f91ba08aacc3)
* [json examples for postman](https://developers.google.com/cloud-messaging/topic-messaging)

### Local notifications

* [Cordova-plugin-local-notifications](https://github.com/katzer/cordova-plugin-local-notifications)


## Firebase remote config

* [cordova-plugin-firebase-config](https://github.com/chemerisuk/cordova-plugin-firebase-config)
* [Complete Firebase Native SDK for Cordova](https://github.com/neilor/cordova-plugin-firebase-native)

## Auto start

<https://github.com/ToniKorin/cordova-plugin-autostart>

    cordova plugin add cordova-plugin-autostart@2.0.1

