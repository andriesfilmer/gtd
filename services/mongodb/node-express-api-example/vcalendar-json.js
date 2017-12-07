// Inspired by https://github.com/steven-elliott/vcard-json

var fs = require ('fs');
var EventEmitter = require("events").EventEmitter;
var moment = require('moment-timezone');
var _ = require ('underscore');
var s = require("underscore.string");

var ee = new EventEmitter();

// https://tools.ietf.org/html/rfc5545

var attributes = {};
attributes.title = "SUMMARY:";
attributes.start = "DTSTART";
attributes.description = "DESCRIPTION";
attributes.className = "PIM-CLASSNAME"; // Not a rfc5545 propertie!
attributes.tz = "DTSTART;TZID=";
attributes.end = "DTEND";

function parseVcalendarFile(pathToFile, callback) {

  fs.readFile(pathToFile, function(err, data) {
    if (err) {
      callback(err);
    }
    else {
      var all_events = parse(data);
      callback(null, all_events);
    }
  });

}

function parse(data) {

  var dataStr = data.toString("utf-8")
  var lines = s(dataStr).lines();
  var all_events = [];
  var vevent;
  var belongsTo = '';

  _.each(lines, function(lineContent) {

    if (s(lineContent).startsWith("BEGIN:VEVENT")) {
      // Init new event
      vevent = {};
      vevent.title = "empty";
      vevent.allDay = 'false';
      vevent.tz = moment.tz.guess();
    }

    if (s(lineContent).trim().startsWith("END:VEVENT")) {
      all_events.push(vevent);
    }

    _.each(attributes, function(attribute){

      if (s(lineContent).startsWith(attribute) && vevent) {

        ee.emit("attributeMatched", attribute, lineContent, vevent); 

        // If we have DESCRIPTION there can be more lines.
        // We add the unknown lines to the last attribute.
        belongsTo = '';
        if (s(lineContent).startsWith('DESCRIPTION')) {
          belongsTo = 'description'
        }

      }
    });

    // belongsTo: Add to DESCRIPTION attribute and skip common iCalendar
    // properties which we don't want in the description.
    var skipProps = ["DESCRIPTION","CREATED","LAST-MODIFIED","DTSTAMP",
      "LOCATION","UID","STATUS","SEQUENCE","X-MOZ-GENERATION","END"];
    skipProps.push(attributes);
    if (!_.contains(skipProps, s(lineContent).strLeft(':').strLeft(';').value()) && belongsTo === 'description') {
      ee.emit("attributeMatched", 'DESCRIPTION-EXT', lineContent, vevent);
    }


  }); // end _.each

  return all_events;
}

function attributeMatched(attribute, line, vevent) {

  switch (attribute) {

    case "SUMMARY:":
      vevent.title = s(line).strRight(':').value();
      break;

    case "DTSTART":
      var start = s(line).strRight(':').clean().value();
      vevent.start = moment(start).toISOString(); 
      break;

    case "DTSTART;TZID=":
      vevent.tz = s(line).strRight('=').strLeft(':').clean().value();
      break;

    case "DESCRIPTION":
      vevent.description = s(line).strRight(':').value()
        .replace(/(\\r\\n|\\n|\\r)/g, '\n');
      break;

    case "DESCRIPTION-EXT":
      vevent.description += s(line).value().replace(/(\\r\\n|\\n|\\r)/g, '\n');
      break;

    case "DTEND":
      var end = s(line).strRight(':').clean().value();
      vevent.end = moment(end).toISOString();
      break;

    case "PIM-CLASSNAME":
      // This propertie is only for export/import PIM.center events.
      // Is not a rfc5545 propertie!
      vevent.className = s(line).strRight(':').clean().value();
      break;

  }
}

ee.on("attributeMatched", attributeMatched);
exports.parseVcalendarFile = parseVcalendarFile;
