var jwt = require('jsonwebtoken');
var nodemailer = require('nodemailer');

var db = require('../config/mongo_database');
var config = require('../config/config.js');
var secret = require('../config/secret');


exports.signin = function(req, res) {

  var email = req.body.email.toLowerCase() || '';
  var password = req.body.password || '';

  if (email == '' || password == '') { 
    return res.sendStatus(401); // Unauthorized
  }

  db.userModel.findOne({email: email}, function (err, user) {

    if (err) {
      console.log(err);
      return res.sendStatus(500); // Internal server error
    }

    if (user == undefined) {
      console.log('users -> signin -> undefined user');
      return res.sendStatus(401); // Unauthorized 
    }

    user.comparePassword(password, function(isMatch) {
      if (!isMatch) {
        return res.sendStatus(401); // Unauthorized
      }

      var token = jwt.sign({id: user._id}, secret.secretToken, { expiresIn: config.expiresIn });
      return res.json({token: token, user_id: user._id, fullname: user.fullname});
    });

  });
};

exports.logout = function(req, res) {

  // Angular has already destroyed the sessionStorage.token
  console.log("Logout -> no user from angular yet! " + req.user);
  if (req.user) {
    delete req.user;  
    return res.send(200); // OK
  }
  else {
    return res.status(401).end(); // Unauthorized
  }
}

exports.register = function(req, res) {

  if (req.body.fullname === undefined) {
    return res.status(400).send('Fullname required');
  }

  var emailRegex = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
  if (!emailRegex.test(req.body.email)){
    return res.status(400).send('Not a valid emailaddress');
  }

  var passwordRegex = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})");
  if (!passwordRegex.test(req.body.password)){
    return res.status(400).send('Password must have 8 characters with numbers, lower- and uppercase');
  }

  if (req.body.passwordConfirmation !== req.body.password) {
    return res.status(400).send('Password and confirm password not equal');
  }

  var user = new db.userModel();

  user.fullname = req.body.fullname;
  user.email = req.body.email.toLowerCase();
  user.password = req.body.password;

  user.save(function(err) {
    console.log('Registered user.save -> ' + user.email);
    if (err) {
      console.log(err);
      return res.sendStatus(500); // Internal Server Error
    }
    return res.sendStatus(200); // Success
  });

}

exports.passwordChange = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Not authorized
  }

  var passwordRegex = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})");
  if (!passwordRegex.test(req.body.password)){
    return res.status(400).send('Password must have 8 characters with numbers, lower- and uppercase');
  }

  if (req.body.passwordConfirmation !== req.body.password) {
    return res.status(400).send('Password and confirm password not equal');
  }

  var user = {};
  db.userModel.findOne({_id: req.user.id}, function (err, user) {

    user.password = req.body.password;
    user.save(function(err) {
      if (err) {
        console.log(err);
        return res.sendStatus(500); // Internal Server Error
      }

      // return user_id and new token with longer expire date.
      var token = jwt.sign({id: user._id}, secret.secretToken, { expiresIn: config.expiresIn });

      return res.json({token: token, user_id: user._id});

    });

  });

}

exports.sendToken = function(req, res) {

  var user = {};
  db.userModel.findOne({email: req.body.email}, function (err, user) {

    if (user) {
      var token = jwt.sign({id: user._id}, secret.secretToken, { expiresIn: "2h" });
      sendMailToken(user, token);
      return res.status(200).send('Email has been send'); // Success
    }
    else {
      return res.status(400).send('E-mail does not exists'); // Bad Request
    }

  });

  // Function for sending a login/change-password token to emailaddress.
  function sendMailToken(user, token) {

    var transporter = nodemailer.createTransport({ 
      port: config.mail_port,
      ignoreTLS: true
    });

    var emailAddress = user.fullname + ' <' + user.email + '>' ; 
    console.log('Send token to: ' + emailAddress + ' Port: ' + config.mail_port); 

    transporter.sendMail({
        from: config.mail_from,
        to: emailAddress,
        subject: 'PIM token to change password',
        text: 'Hello ' + user.fullname + ',\n\n'
          + 'Someone has requested a token to reset your password (probably you).\n\n'
          + 'Just click on this link and change your password:\n'
          + config.cors_url[0] + '/#/user/change-password/' + token + '/' + user._id + '\n\n'
          + 'If you didn\'t mean to reset your password, then you can just ignore this email; your password will not change.\n\n'
          + 'Regards Andries Filmer.\n'
          + 'http://pim.center\n'

    });

  }

}
