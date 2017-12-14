## Cordova

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

    ./Android/Sdk/emulator/emulator  -list-avds
    ./Android/Sdk/emulator/emulator  @Nexus_5X_API_26_x86

Inspect via Chrome

In the locationbar `chrome://inspect/#devices`

### ADB

Get list of contacts

    content query --uri content://contacts/people/ --where 'number is null' --projection _id

## Vue-cordova-webpack

**Onsen UI**

A full-featured Webpack setup with hot-reload, lint-on-save, unit testing & css extraction

<https://github.com/OnsenUI/vue-cordova-webpack>

**Vuetify**

Material Component Framework

<https://vuetifyjs.com/>
<https://github.com/vuetifyjs/vuetify>


**Vue.js plugin for Cordova**

<https://github.com/kartsims/vue-cordova>

**Framework7 Vue**

Bring components-syntax, structured data and data bindings to Framework7 with power and simplicity of Vue.js

<http://framework7.io/vue/>

## Ionic

### Dashboard

<https://dashboard.ionicjs.com/apps>

To run in browser

    ionic serve

### First steps

    sudo npm install -g fsevents
    sudo npm install -g @ionic/app-scripts


To run or build your app for production, run  
Connect your android with a usb, check with `adb list`

    ionic cordova run android --prod --release

* <http://ionicframework.com/docs/intro/deploying/>


