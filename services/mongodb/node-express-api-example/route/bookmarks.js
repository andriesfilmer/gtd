var secret = require('../config/secret');
var db = require('../config/mongo_database');

exports.list = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var query = db.bookmarkModel.find({user_id: req.user.id}).limit(parseInt(req.query.limit));

  query.select("_id title url category tags created updated public");
  query.sort('-updated');
  query.exec(function(err, results) {

    if (err) {
      console.log(err);
      return res.sendStatus(400); // Bad Request
    }

    if (results === null) {
      return res.sendStatus(404); // Not Found
    }
    else {
      return res.status(200).json(results); // OK
    } 

  });

};

exports.search = function(req, res) {

  var bookmarks = req.query; 

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  if (bookmarks.searchKey) {
    var query = db.bookmarkModel.find({ $or: [ 
                                          {title:   { $exists: true, $regex: bookmarks.searchKey, $options: 'i' } },
                                          {content: { $exists: true, $regex: bookmarks.searchKey, $options: 'i' } }, 
                                          {tags:    { $exists: true, $regex: bookmarks.searchKey, $options: 'i' } } 
                                         ],user_id: req.user.id } );
  } else {
    var query = db.bookmarkModel.find({ user_id: req.user.id });
  }

  query.select("_id title url category tags created updated public");
  query.sort('-updated');
  query.limit(parseInt(req.query.limit));
  query.exec(function(err, results) {

    if (err) {
      console.log(err);
      return res.sendStatus(400); // Bad Request
    }

    if (results === null) {
      return res.sendStatus(404); // Not Found
    }
    else {
      return res.status(200).json(results); // OK
    }

  });

};

exports.read = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var id = req.params.id || '';
  if (id === '') {
    return res.sendStatus(400); // Bad Request
  }

  var query = db.bookmarkModel.findOne({ _id: id, user_id: req.user.id });
  query.select('_id title url category content tags created updated public');
  query.exec(function(err, result) {

    if (err) {
        console.log(err);
        return res.sendStatus(400); // Bad Request
    }

    if (result === null) {
      return res.sendStatus(400); // Bad Request
    }

    return res.status(200).json(result);

  });
}; 

exports.create = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var bookmark = req.body.bookmark;
  if (bookmark == null) {
    return res.sendStatus(400); // Bad Request
  }

  var bookmarkEntry = new db.bookmarkModel();

  bookmarkEntry.user_id = req.user.id;

  // Title required
  if (bookmark.title !== undefined && bookmark.title !== null && bookmark.title !== "") {
    bookmarkEntry.title = bookmark.title;
  }
  else {
    return res.sendStatus(400); // Bad Request
  }

  bookmarkEntry.url = bookmark.url;
  bookmarkEntry.public = bookmark.public;
  bookmarkEntry.content = bookmark.content;
  bookmarkEntry.category = bookmark.category;

  // Tags are comma separated
  if (bookmark.tags != null) {
    if (Object.prototype.toString.call(bookmark.tags) === '[object Array]') {
      bookmarkEntry.tags = bookmark.tags;
    }
    else {
      bookmarkEntry.tags = bookmark.tags.split(',');
    }
  }

  bookmarkEntry.save(function(err) {
    if (err) {
      return res.sendStatus(400); // Bad Request
    }

    return res.status(201).send('Created bookmark successfull');

  });
}

exports.update = function(req, res) {

  if (!req.user) {
    return res.send(401); // Not authorized
  }

  var bookmark = req.body.bookmark;
  if (bookmark == null) {
    res.sendStatus(400); // Bad request
  }

  var updateBookmark = {};

  // Title required
  if (bookmark.title !== null && bookmark.title !== "" && bookmark.title !== undefined) {
    updateBookmark.title = bookmark.title;
  }

  // Convert commaseparate tags to objects.
  if (bookmark.tags != null) {
    if (Object.prototype.toString.call(bookmark.tags) === '[object Array]') {
      updateBookmark.tags = bookmark.tags;
    }
    else {
      updateBookmark.tags = bookmark.tags.split(',');
    }
  }

  if (bookmark.url !== undefined) {
    updateBookmark.url = bookmark.url;
  }

  if (bookmark.category !== undefined) {
    updateBookmark.category = bookmark.category;
  }

  if (bookmark.public !== undefined) {
    updateBookmark.public = bookmark.public;
  }

  if (bookmark.content !== undefined) {
    updateBookmark.content = bookmark.content;
  }

  updateBookmark.updated = new Date();

  db.bookmarkModel.update({_id: bookmark._id, user_id: req.user.id}, updateBookmark, function(err, nbRows, raw) {
    return res.status(200).send('Updated bookmark successfull');
  });

};

exports.delete = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var id = req.params.id;
  if (id == null || id == '') {
    res.sendStatus(400); // Bad request
  }

  var query = db.bookmarkModel.findOne({_id:id});

  query.exec(function(err, result) {
    if (err) {
      console.log(err);
      return res.sendStatus(400); // Bad request
    }

    if (result === undefined) {
      return res.sendStatus(404); // Not Found
    } else {
      result.remove();
      return res.status(200).send('Deleted bookmark successfull');
    }

  });
};

exports.listByTag = function(req, res) {

  var tagName = req.params.tagName || '';
  if (tagName == '') {
    return res.sendStatus(400);
  }

  var query = db.bookmarkModel.find({tags: tagName, public: true, user_id: req.user.id });
  query.select('_id title url tags category created updated public');
  query.sort('-created');
  query.exec(function(err, results) {
    if (err) {
      console.log(err);
      return res.sendStatus(400);
    }

    for (var bookmarkKey in results) {
      results[bookmarkKey].content = results[bookmarkKey].content.substr(0, 400);
    }

    return res.status(200).json(result);
  });
}

