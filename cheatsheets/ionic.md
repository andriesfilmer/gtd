# Ionic cheatsheet

## First steps

    sudo npm install -g fsevents
    sudo npm install -g @ionic/app-scripts


Run ionic in browser with device views

    ionic serve --lab

To run or build your app for production, run one of these:

    ionic cordova platform add android@6.3.0
    ionic cordova run android --prod --release
    # or
    ionic cordova build android --prod --release

## Deploying

* [Ionic Framework deploying](http://ionicframework.com/docs/intro/deploying/)
* [Ionic Framework + CodePush](https://medium.com/@ClemMakesApps/ionic-framework-codepush-115b38d187fb)


Sign the app with keytool

* [Authenticating Your Client](https://developers.google.com/android/guides/client-auth) 


## Ionic 2+ push notifications


### Firebase Cloud Messaging (FCM)

FCM is the library that you need to use in your application to receive cloud messages. It includes client APIs (multi-platform) to receive messages, and server APIs (HTTP and XMPP) to send messages.

#### Firebase Notifications
is the tool integrated in the Firebase Console to schedule cloud messages. This also includes the integration with Firebase Analytics to target analytics-based audiences and track opening and conversion events.


* Goto [Firebase console](https://console.firebase.google.com/) -> select/create your project
* Add Firebase to your Android app
 * Android package name must be the same as `widget id` in your `config.xml`!
 * Save `google.services.json` in the root of your app
* Add Firebase to your iOS app
 * Save `GoogleService-Info.plist` in the root of you app


Removing and adding again the android platform in cordova if you have any issue!

### Amazon Pinpoint

* <https://aws.amazon.com/blogs/mobile/push-notifications-with-ionic-and-amazon-pinpoint/>

### resources

* [Cordova Plugin Firebase - Ionic official](https://github.com/arnesson/cordova-plugin-firebase)
* [Cordova Plugin Firebase - With more functions](https://github.com/co-mmons/cordova-plugin-firebase)
* [Yet a other example](http://www.damirscorner.com/blog/posts/20170804-FirebasePushNotificationsInIonicAndCordova.html)
* [Youtube Cordova plugin firebase](https://www.youtube.com/watch?v=DvRGNrGpI_A)
* [Ionic 2+ push notifications with FCM](https://medium.freecodecamp.org/ionic-2-push-notifications-with-fcm-2a9078b90fe7)

