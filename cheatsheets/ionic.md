# Ionic cheatsheet

## First steps

    sudo npm install -g fsevents
    sudo npm install -g @ionic/app-scripts


To run or build your app for production, run

    ionic cordova run android --prod --release
    # or
    ionic cordova build android --prod --release


To run in browser

    ionic serve


## Deploying

To run or build your app for production, run  
Connect your android with a usb, check with `adb list`

    ionic cordova run android --prod --release

* [Ionic Framework deploying](http://ionicframework.com/docs/intro/deploying/)
* [Ionic Framework + CodePush](https://medium.com/@ClemMakesApps/ionic-framework-codepush-115b38d187fb)


## Ionic 2+ push notifications with FCM

* Goto [Firebase console](https://console.firebase.google.com/) -> select/create your project

<https://medium.freecodecamp.org/ionic-2-push-notifications-with-fcm-2a9078b90fe7>

* Add Firebase to your Android app
* Add Firebase to your iOS app
* Add Firebase to your web app


[Ionic2-code-push-example](https://github.com/ksachdeva/ionic2-code-push-example)
