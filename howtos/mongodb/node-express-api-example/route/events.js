var fs = require('fs');
var secret = require('../config/secret');
var db = require('../config/mongo_database');
var config = require('../config/config.js');
var calendar = require('../vcalendar-json');
var moment = require('moment');
var functions = require('../functions');
var quotedPrintable = require('quoted-printable');
//var util = require('util');

exports.list = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }


  if (req.query.end === undefined) { req.query.end = '3000-01-01' };

  // Remove quotes and use only date (YYYY-mm-dd)
  var start = req.query.start.replace(/"/g,"").substr(0,10);
  var end = req.query.end.replace(/"/g,"").substr(0,10);

  var query = db.eventModel.find({ $or: [
                                   {"start": {"$gte": start, "$lte": end }},
                                   {  "end": {"$gte": start, "$lte": end }}
                                   ], user_id: req.user.id }).limit(500);
  query.select("_id title start end allDay tz className");
  query.sort('start');
  query.exec(function(err, results) {
    if (err) {
      console.log(err);
      return res.sendStatus(400); // Bad Request
    }
    return res.status(200).json(results); // OK
  });

};

// Search calendar
exports.search = function(req, res) {

  var calendar = req.query; 

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  if (calendar.searchKey) {
    var query = db.eventModel.find({ $or: [ 
                                          {title:   { $exists: true, $regex: calendar.searchKey, $options: 'i' } },
                                          {description: { $exists: true, $regex: calendar.searchKey, $options: 'i' } }
                                         ], user_id: req.user.id } ).limit(100);
  } else {
    var query = db.eventModel.find({ user_id: req.user.id });
  }

  query.select("_id title start end allDay className created updated");
  query.sort('-start');
  query.exec(function(err, results) {

    if (err) {
      console.log(err);
      return res.sendStatus(400); // Bad Request
    }

    if (results !== null) {
      return res.status(200).json(results); // OK
    }
    else {
      return res.sendStatus(404); // Not Found
    }

  });

};

exports.read = function(req, res) {

  if (!req.user) {
    return res.send(401); // Unauthorized
  }

  var id = req.params.id || '';
  if (!id.match(/^[0-9a-fA-F]{24}$/)) {
    return res.sendStatus(406); // Not Acceptable
  }

  var query = db.eventModel.findOne({ _id: id, user_id: req.user.id });
  query.select('_id title start end allDay tz description className created updated');
  query.exec(function(err, result) {
    if (err) {
        console.log(err);
    }

    if (result !== null) {
      return res.status(200).json(result);
    } else {
      return res.sendStatus(404); // Not found
    }
  });

}; 

exports.create = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var event = req.body.calendar;
  if (event == null) {
    return res.sendStatus(400); // Bad Request
  }

  var createEvent = new db.eventModel();

  createEvent.user_id = req.user.id;

  // Title required
  if (event.title !== undefined && event.title !== null && event.title !== "") {
    createEvent.title = event.title;
  }
  else {
    return res.sendStatus(400); // Bad Request
  }

  // Start required
  if (event.start !== undefined && event.start !== "" && event.start !== null) {
    createEvent.start = event.start;
  }
  else {
    return res.sendStatus(400); // Bad Request
  }

  if (event.end !== undefined) {
    createEvent.end = event.end;
  }

  if (event.tz !== undefined) {
    createEvent.tz = event.tz;
  }

  if (event.description !== undefined) {
    createEvent.description = event.description;
  }

  if (event.className !== undefined) {
    createEvent.className = event.className;
  }

  if (event.allDay !== undefined) {
    createEvent.allDay = event.allDay;
  }

  createEvent.save(function(err) {
    if (err) {
      console.log(err);
      return res.sendStatus(400); // Bad Request
    }
    return res.status(200).send('Created event successfull');
  });
}

exports.update = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var event = req.body.calendar;

  if (event == null || event._id == null) {
    res.sendStatus(404); // Not found
  }

  // Title required
  var updateEvent = {};
  if (event.title !== undefined && event.title !== "" && event.title !== null) {
    updateEvent.title = event.title;
  }
  else {
    return res.sendStatus(400); // Bad Request
  }

  // Start required
  if (event.start !== undefined && event.start !== "" && event.start !== null) {
    updateEvent.start = event.start;
  }
  else {
    return res.sendStatus(400); // Bad Request
  }

  if (event.end !== undefined) {
    updateEvent.end = event.end;
  }

  if (event.tz !== undefined) {
    updateEvent.tz = event.tz;
  }

  if (event.description !== undefined) {
    updateEvent.description = event.description;
  }

  if (event.allDay !== undefined) {
    updateEvent.allDay = event.allDay;
  }

  if (event.className !== undefined) {
    updateEvent.className = event.className;
  }

  updateEvent.updated = new Date();

  db.eventModel.update({_id: event._id, user_id: req.user.id}, updateEvent, function(err, nbRows, raw) {
    if (err) {
      console.log(err);
      return res.sendStatus(400);
    }

    return res.status(200).send('Updeted event successfull');

  });

};

exports.delete = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var id = req.params.id;
  if (id === null || id === undefined || id === '') {
    res.send(400); // Bad request
  }

  var query = db.eventModel.findOne({_id: id, user_id: req.user.id});
  query.exec(function(err, result) {
    if (err) {
      console.log(err);
      return res.send(400); // Bad request
    }

    if (result === null) {
      return res.sendStatus(400); // Bad request
    } else {
      result.remove();
      return res.status(200).send('Deleted event successfull');
    }

  });
};

exports.vCalendarUpload = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var calendarDir = config.env().upload_dir + req.user.id + "/calendars/";
  if (!fs.existsSync(calendarDir)) { functions.mkdir(calendarDir); }

  // First save upload file to disk
  req.pipe(req.busboy);
  req.busboy.on('file', function(fieldname, file, filename, encoding, mimetype) {

    if (mimetype.toString() === 'text/calendar') {

      var vCalendarPath = calendarDir + filename;

      fstream = fs.createWriteStream(vCalendarPath);
      file.pipe(fstream);
      fstream.on('close', function() {
        console.log("Upload Finished of " + vCalendarPath);
        importEvents(vCalendarPath);
      });
    }
    else {
      return res.status(400).send('File type must be text/calendar');
    }
  });

  // Function to import calendars from file
  function importEvents(vCalendar) {
    console.log('Import calendars from file -> ' + vCalendar); 
    calendar.parseVcalendarFile(vCalendar, function(err, data){
      if(err) {
        return res.status(400).send('Bad Request parseCalendarFile');
      }
      else {

        // Debug info, uncomment/include 'utils' at the top.
        //console.log(util.inspect(data, false, null));

        count = 0;
        data.forEach(function(event) {
          var eventEntry = new db.eventModel();
          count++;
          eventEntry.user_id = req.user.id;
          eventEntry.title = event.title;
          eventEntry.start = event.start;
          eventEntry.end = event.end;
          eventEntry.allDay = event.allDay;
          if (event.description != '' && event.description !== undefined) {
            eventEntry.description = quotedPrintable.decode(event.description);
          }
          eventEntry.tz = event.tz;

          // If no 'PIM-CLASSNAME' property is included in the EVENT
          // we use 'importclassname' form the header which comes from PIM.center.
          event.className === undefined ? eventEntry.className = req.headers.importclassname : eventEntry.className = event.className;

          // Save event to db.
          eventEntry.save(function(err) {
            if (err) {
              console.log(err);
            }
          });

        });

        res.status(200).send(count + ' events successful created');
      }
    });
  } // End function importCalendars

};

exports.veventsDownload = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var query = db.eventModel.find({ user_id: req.user.id });
  query.sort('start');
  query.exec(function(err, results) {

    if (err) {
      console.log(err);
      res.status(500).send(err);
    }

    if (results !== null) {

      // Concat vevents
      // https://tools.ietf.org/html/rfc5545
      var icsContent = '';
      icsContent  += "BEGIN:VCALENDAR\n";
      icsContent  += "VERSION:2.0\n";
      results.forEach(function(event){
        icsContent += create_vEvent(req, event);
      });
      icsContent += "END:VCALENDAR\n";

      // Download as data stream.
      res.status(200).send(icsContent);

    }
  });
};

exports.veventDownload = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  console.log('Create vEvent for event_id -> ' + req.body.params.event_id); 

  var query = db.eventModel.findOne({ user_id: req.user.id, _id: req.body.params.event_id });
  query.exec(function(err, result) {

    if (err) {
      console.log(err);
      res.status(500).send('Internal Server Error');
    }

    if (result !== null) {
        icsContent = create_vEvent(req, result);
        res.status(200).send(icsContent);
    }
  });
};

// Content for one vevent.
function create_vEvent(req, event) {

  icsContent  = 'BEGIN:VEVENT\n';
  icsContent += 'SUMMARY:' + event.title + '\n';
  icsContent += 'DTSTART;TZID=' + event.tz + ':' + moment(event.start).toISOString().replace(/(:|-)/g,'') + '\n';
  icsContent += 'DTEND;TZID=' + event.tz + ':' + moment(event.end).toISOString().replace(/(:|-)/g,'') + '\n';
  icsContent += 'PIM-CLASSNAME:' + event.className + '\n';
  // Description SHOULD NOT be longer than 75 octets, excluding the line break
  if (event.description !== undefined) {
    var desc = 'DESCRIPTION:' + event.description;
    icsContent += desc.replace(/(\r\n|\n|\r)/g,'\\n').replace(/(.{1,73})/g, '$1 \r\n ') + '\n';
  }
  icsContent += 'END:VEVENT\n';

  return icsContent;
}
