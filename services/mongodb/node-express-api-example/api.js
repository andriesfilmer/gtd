var express = require('express');

/**************/
// Middleware */
/**************/

// Validates JsonWebTokens and set req.user.
var expressJwt = require('express-jwt');

// body-parsing middleware to populate req.body.
var bodyParser = require('body-parser');

// CORS - Access-Control-Allow-Origin
var cors = require('cors');

// Upload profile pictures
var busboy = require('connect-busboy');

/**************/
// Config     */
/**************/

// This file is in .gitignore. You have to create it (zie readme.md)
var secret = require('./config/secret');

var config = require('./config/config.js');
var config = config.env();
var corsOptions = { origin: config.cors_url}; 

// Use Express Framework.
var app = express();

// For production use upstream (nginx.conf).
app.listen(config.api_port);

app.use(cors(corsOptions));
app.use(bodyParser.json({limit: '1mb'})); // limit for PNG photo's upload via DataUrl.
app.use(busboy()); 


console.log('API (' + config.name + ') is starting on port ' + config.api_port);

// Routes
var routes = {};
routes.users = require('./route/users.js');
routes.events = require('./route/events.js');
routes.contacts = require('./route/contacts.js');
routes.posts = require('./route/posts.js');
routes.bookmarks = require('./route/bookmarks.js');

/*******************/
// User routes     */
/*******************/
app.post('/user/register', routes.users.register); 

// Login
app.post('/user/signin', routes.users.signin); 

// Logout
app.get('/user/logout', routes.users.logout); 

// Password change
app.post('/user/password-change', expressJwt({secret: secret.secretToken, credentialsRequired: false}), routes.users.passwordChange);

// Send token to emailaddress
app.post('/user/send-token', routes.users.sendToken);

/*******************/
/* Event routes    */
/*******************/

// Get all events
app.get('/calendar/events', expressJwt({secret: secret.secretToken}), routes.events.list);

// Search events
app.get('/calendar/search', expressJwt({secret: secret.secretToken}), routes.events.search);

// Get the event (id)
app.get('/calendar/:id', expressJwt({secret: secret.secretToken}), routes.events.read); 

// Create a new event item
app.post('/calendar', expressJwt({secret: secret.secretToken}), routes.events.create); 

// Update event item (id)
app.put('/calendar', expressJwt({secret: secret.secretToken}), routes.events.update); 

// File upload for vCalendar
app.post('/calendar/upload/vcalendar', expressJwt({secret: secret.secretToken}), routes.events.vCalendarUpload); 

// File download for calendar event(s) in iCalendar format.
app.post('/calendar/download/vevents', expressJwt({secret: secret.secretToken}), routes.events.veventsDownload); 
app.post('/calendar/download/vevent', expressJwt({secret: secret.secretToken}), routes.events.veventDownload); 

// Delete event item (id)
app.delete('/calendar/:id', expressJwt({secret: secret.secretToken}), routes.events.delete); 

/*******************/
/* Contacts routes    */
/*******************/

// Get all contacts
app.get('/contacts', expressJwt({secret: secret.secretToken}), routes.contacts.list);

// Search contacts
app.get('/contacts/search', expressJwt({secret: secret.secretToken}), routes.contacts.search);

// Get the contact id
app.get('/contact/:id', expressJwt({secret: secret.secretToken}), routes.contacts.read); 

// Create a new contact
app.post('/contact', expressJwt({secret: secret.secretToken}), routes.contacts.create); 

// Edit the contact id
app.put('/contact', expressJwt({secret: secret.secretToken}), routes.contacts.update); 

// File download for contact(s) in vCard format.
app.post('/contacts/download/vcard', expressJwt({secret: secret.secretToken}), routes.contacts.vcardsDownload); 
app.post('/contact/download/vcard', expressJwt({secret: secret.secretToken}), routes.contacts.vcardDownload); 

// File upload for profile pictures
app.post('/contact/upload/photo', expressJwt({secret: secret.secretToken}), routes.contacts.photoUpload); 

// File upload for vCards
app.post('/contact/upload/vcards', expressJwt({secret: secret.secretToken}), routes.contacts.vCardsUpload); 

// Delete the contact id
app.delete('/contact/:id', expressJwt({secret: secret.secretToken}), routes.contacts.delete); 


/*******************/
/* Posts routes    */
/*******************/

// Get all posts
app.get('/posts', expressJwt({secret: secret.secretToken}), routes.posts.list);

// Search posts
app.get('/posts/search', expressJwt({secret: secret.secretToken}), routes.posts.search);

// Get the post id
app.get('/post/:id', expressJwt({secret: secret.secretToken}), routes.posts.read); 
app.post('/post/pdf/:id', expressJwt({secret: secret.secretToken}), routes.posts.pdf); 
app.get('/post/version/:id', expressJwt({secret: secret.secretToken}), routes.posts.readVersion); 
app.get('/post/versions/:id', expressJwt({secret: secret.secretToken}), routes.posts.listVersions); 

// Create a new post
app.post('/post', expressJwt({secret: secret.secretToken}), routes.posts.create); 

// Edit the post id
app.put('/post', expressJwt({secret: secret.secretToken}), routes.posts.update); 

// Delete the post id
app.delete('/post/:id', expressJwt({secret: secret.secretToken}), routes.posts.delete); 

/*******************/
/* Bookmark routes    */
/*******************/

// Search bookmarks
app.get('/bookmarks/search', expressJwt({secret: secret.secretToken}), routes.bookmarks.search);

// Get all bookmarks
app.get('/bookmarks', expressJwt({secret: secret.secretToken}), routes.bookmarks.list);

// Get the bookmark id
app.get('/bookmark/:id', expressJwt({secret: secret.secretToken}), routes.bookmarks.read); 

// Create a new bookmark
app.post('/bookmark', expressJwt({secret: secret.secretToken}), routes.bookmarks.create); 

// Edit the bookmark id
app.put('/bookmark', expressJwt({secret: secret.secretToken}), routes.bookmarks.update); 

// Delete the bookmark id
app.delete('/bookmark/:id', expressJwt({secret: secret.secretToken}), routes.bookmarks.delete); 
