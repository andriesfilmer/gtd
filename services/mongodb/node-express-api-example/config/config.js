// Take a look in `env.json` form enviroment vars.
var env = require('./env.json');

exports.env = function() {
  var node_env = process.env.NODE_ENV || 'development';
  return env[node_env];
};

// Development and productions vars·
// ---------------------------------

exports.expiresIn = "365d";


// Default location to store the uploaded photos.
exports.default_upload_photo_dir = '../app/public/upload/contact_photos/';
