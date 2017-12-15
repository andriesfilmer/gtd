## Cordova

* [Cordova docs](https://cordova.apache.org/docs/)

### Add Firebase to your Android app

* <https://pusher.com/docs/push_notifications/android/fcm>
* <https://ionicframework.com/docs/native/push/>

    cordova plugin add cordova-plugin-fcm
    ionic cordova plugin add phonegap-plugin-push
    ionic cordova run android --prod --release

## Android Studio

Configure Emulator

If you do not need sound in your emulator you can disable it by editing  ~/.android/avd/<AVD_Name>.avd/config.ini

    hw.audioInput=no
    hw.audioOutput=no

Start Emulator

    ~/Android/Sdk/emulator/emulator  -list-avds
    ~/Android/Sdk/emulator/emulator  @Nexus_5X_API_26_x86

Inspect via Chrome

In the locationbar `chrome://inspect/#devices`

### ADB

Get list of contacts

    content query --uri content://contacts/people/ --where 'number is null' --projection _id


## Cordova plugins

[CordavaCall](https://github.com/WebsiteBeaver/CordovaCall) | Good example
