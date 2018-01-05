///////////////////////////////////////////////////////////////////////////////
//
// Created 05-01-2018 by Andries Filmer
//
// This example is created from https://github.com/google/google-api-nodejs-client
// Use this example as inspiration for development ;)
//
// This 'test' script has three actions
//
// 1 - getRefreshToken (only the first time)
// 2 - getUserInfo (with tokens)
// 3 - getNewTokens  (refresh all tokens)
//
// Set each of these 'actions' to true (each after another)
//
///////////////////////////////////////////////////////////////////////////////

'use strict';

var readline = require('readline');
var google = require('googleapis');
var googleAuth = require('google-auth-library');

var auth = new googleAuth();
var OAuth2Client = auth.OAuth2;
var plus = google.plus('v1');

// Get these vars from your project on https://console.developers.google.com/apis/credentials
//
var CLIENT_ID = '';
var CLIENT_SECRET = '';
var REDIRECT_URL = '';


// getRefreshToken is the first action. It creates a login url and feches user info.
//
// With the url you get a `code` back as parameter to the callback url which
// you have set in your project. Copy and paste this `code` on the prompt (if asked for).
//
// The reponse gives a `one time only` refresh_token! Remove your app on
// `https://myaccount.google.com/permissions` to test again.
//
// Enable getRefreshToken to start the first session.
//
var getRefreshToken = false; // Action disabled.

// Set tokens from request function `getRefreshToken`.
//
var ACCESS_TOKEN = '';
var REFRESH_TOKEN = '';
var EXPIRY_DATE = (new Date()).getTime() + (1000 * 60 * 60 * 24 * 7);

// Enable getUserInfo to request user info with tokens set from `scope`
//
var getUserInfo = false; // Action disabled.

// Enable getNewTokens with the old  (not yet expired) tokens.
//
var getNewTokens = false; // Action disabled.

//-------------------------- end settings ---------------------------------------//

var oauth2Client = new OAuth2Client(CLIENT_ID, CLIENT_SECRET, REDIRECT_URL);
oauth2Client.credentials = {
  access_token: ACCESS_TOKEN,
  refresh_token: REFRESH_TOKEN,
  token_type: "Bearer",
  expiry_date: EXPIRY_DATE
};

var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function getAccessToken (oauth2Client, callback) {

  // Show this `url` as button `Login with Google` on you login page.
  var url = oauth2Client.generateAuthUrl({
    access_type: 'offline', // Will return a refresh token only the first time.
    scope: 'email' // Scope to basic account info.
  });

  // The callback url set in your project on https://console.developers.google.com wil send
  // a response with `code` as a parameter. Fetch this `code` to get the tokens.
  //
  console.log('Visit the url: ', url);
  rl.question('Enter the code here:', function (code) {
    oauth2Client.getToken(code, function (err, tokens) {

      if (err) {
        return callback(err);
      }

      // This will set the tokens to get user info.
      oauth2Client.credentials = tokens;

      // show 'access_token, refresh_token, id_token, etc' in your console.
      console.dir(tokens);

      callback();

    });
  });
}

if (getRefreshToken) {

  // Start session -> Create url -> fetch code -> set tokens -> show user info.
  getAccessToken(oauth2Client, function () {
    plus.people.get({ userId: 'me', auth: oauth2Client }, function (err, response) {
      if (err) {
        return console.log('An error occured', err);
      }
      // show user info.
      console.dir(response);
    });
  });
}


if (getUserInfo) {
  plus.people.get({ userId: 'me', auth: oauth2Client }, function (err, response) {
     if (err) {
       return console.log('An error occured', err);
     }
     // show user info.
     console.dir(response);
  });
}


if (getNewTokens) {
  oauth2Client.refreshAccessToken(function(err, tokens) {
     if (err) {
       return console.log('An error occured', err);
     }
     // Show new tokens.
     console.dir(tokens);
  });
}
