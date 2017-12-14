// Inspired by https://github.com/steven-elliott/vcard-json

var fs = require ('fs');
var EventEmitter = require("events").EventEmitter;
var moment = require('moment');
var _ = require ('underscore');
var s = require("underscore.string");

var ee = new EventEmitter();
var attributes = {};
// https://tools.ietf.org/html/rfc6350
attributes.name = "N:";
attributes.fullname = "FN";
attributes.company = "ORG";
attributes.websites = "URL";
attributes.email = "EMAIL";
attributes.phone = "TEL";
attributes.birthdate = "BDAY";
attributes.photo = "PHOTO";
attributes.notes = "NOTE";
attributes.addres = "ADR";

function parseVcardFile(pathToFile, callback) {

  fs.readFile(pathToFile, function(err, data) {
    if (err) {
      callback(err);
    }
    else {
      var all_contacts = parse(data);
      callback(null, all_contacts);
    }
  });

}

function parse(data) {

  var dataStr = data.toString("utf-8")
  var lines = s(dataStr).lines();
  var all_contacts = [];
  var contact;
  var belongsTo = '';

  _.each(lines, function(lineContent) {

    if (s(lineContent).startsWith("BEGIN:VCARD")) {
      contact = {};
      contact.name = "empty";
      contact.companies = [];
      contact.phones = [];
      contact.emails = [];
      contact.websites = [];
      contact.addresses = [];
      belongsTo = '';
    }

    if (s(lineContent).trim().startsWith("END:VCARD")) {
      all_contacts.push(contact);
    }

    _.each(attributes, function(attribute){

      if (s(lineContent).startsWith(attribute)) {

        ee.emit("attributeMatched", attribute, lineContent, contact); 

        // If we have NOTE or PHOTO attributes there are more lines.
        // We add the unknown lines to the last attribute.
        belongsTo = '';
        if (s(lineContent).startsWith('PHOTO')) {
          belongsTo = 'photo'
        }
        if (s(lineContent).startsWith('NOTE')) {
          belongsTo = 'note';
        }

      }
    });

    // Add 'belongsTo' line to NOTE attribute.
    if (!_.contains(attributes, s(lineContent).strLeft(':').strLeft(';').value()) && belongsTo === 'note') {
      ee.emit("attributeMatched", 'NOTE_EXT', lineContent, contact);
    }
    // Add 'belongsTo' line to PHOTO attribute.
    if (!_.contains(attributes, s(lineContent).strLeft(';').value()) && belongsTo === 'photo') {
      ee.emit("attributeMatched", 'PHOTO_EXT', lineContent, contact); 
    }


  }); // end _.each

  return all_contacts;
}

function attributeMatched(attribute, line, contact) {

  switch (attribute) {
    case "N:":
      if (contact.name === 'empty') contact.name = s(line).
         strRight(':').trim(';').clean().value();
      break;

    case "FN":
      contact.name = s(line).strRight(':').value();
      break;

    case "ORG":
      var company_obj = {};
      company_obj.name = s(line).strRight(':').clean().value();
      company_obj.title = s(line.replace(/(org|type|=|;)/ig,' ')).
        strLeft(':').toLowerCase().clean().capitalize().value();
      contact.companies.push(company_obj);
      break;

    case "EMAIL":
      var email_obj = {};
      email_obj.type = s(line.replace(/(email|type|=|x-|;)/ig,' ')).
        strLeft(':').toLowerCase().clean().capitalize().value();
      email_obj.value = s(line).strRight(':').clean().value();
      // Add extra object 'default'if pref exists.
      if (line.search(/(type=pref|;pref)/i) > 0) { email_obj.default = true; }
      contact.emails.push(email_obj);
      break;

    case "TEL":
      var phone_obj = {};
      phone_obj.type = s(line.replace(/(tel|type|=|pref|x-|voice|;)/ig,' ')).
        strLeft(':').toLowerCase().replace(/cell/,'Mobile').clean().capitalize().value();
      phone_obj.value = s(line).strRight(':').clean().value();
      if (line.search(/(type=pref|;pref)/i) > 0) { phone_obj.default = true; }
      contact.phones.push(phone_obj);
      break;

    case "URL":
      var website_obj = {};
      website_obj.type = s(line.replace(/(url|type|=|;)/ig,' ')).
        strLeft(':').toLowerCase().clean().capitalize().value();
      website_obj.value = s(line).strRight(':').clean().value();
      contact.websites.push(website_obj);
      break;

    case "ADR":
      var address_obj = {};
      address_obj.type = s(line.replace(/(adr|type|=|;)/ig,' ')).
        strLeft(':').toLowerCase().clean().capitalize().value();
      address_obj.value = s(line.replace(/;/g,', ')).strRight(':').trim(',').clean().value();
      if (line.search(/(type=pref|;pref)/i) > 0) { address_obj.default = true; }
      contact.addresses.push(address_obj);
      break;

    case "BDAY":
      var birthdate = new Date(s(line).strRight(':').clean().value());
      if (birthdate.toString() !== 'Invalid Date') {
        contact.birthdate = moment(birthdate).format("YYYY-MM-DD");
      }
      break;

    case "PHOTO":
      if (s(line).strLeft(':').include('PNG')) {
        contact.photo_uri = 'data:image/png;base64,';
      } else if (s(line).strLeft(':').include('JPEG')) {
        contact.photo_uri = 'data:image/jpeg;base64,';
      }
      contact.photo_uri += s(line).strRight(':').clean().value();
      break;

    case "PHOTO_EXT":
      contact.photo_uri += s(line).clean().value();
      break;

    case "NOTE":
      contact.notes = s(line).strRight(':').value() + '\n';
      break;

    case "NOTE_EXT":
      line = s(line.replace(/END:VCARD/ig,'')).value();
      contact.notes += line + '\n';
      break;

  }
}

ee.on("attributeMatched", attributeMatched);
exports.parseVcardFile = parseVcardFile;
