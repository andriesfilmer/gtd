var secret = require('../config/secret');
var db = require('../config/mongo_database');
var fs = require('fs');
var markdownpdf = require("markdown-pdf");

exports.list = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var query = db.postModel.find({user_id: req.user.id}).limit(parseInt(req.query.limit));

  query.select("_id title type tags created updated public");
  query.sort('-updated');
  query.exec(function(err, results) {

    if (err) {
      console.log(err);
      return res.sendStatus(400); // Bad Request
    }

    if (results !== null) {
      return res.status(200).json(results); // OK
    } else {
      return res.sendStatus(404); // Not Found
    }

  });

};

exports.search = function(req, res) {

  var posts = req.query; 

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  if (posts.searchKey) {
    var query = db.postModel.find({ $or: [ 
                                          {title:   { $exists: true, $regex: posts.searchKey, $options: 'i' } },
                                          {content: { $exists: true, $regex: posts.searchKey, $options: 'i' } }, 
                                          {tags:    { $exists: true, $regex: posts.searchKey, $options: 'i' } } 
                                         ],user_id: req.user.id } );
  }
  else {
    var query = db.postModel.find({user_id: req.user.id});
  }

  query.select("_id title type tags created updated public");
  query.sort('-updated');
  query.limit(parseInt(req.query.limit));
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
    return res.sendStatus(401); // Unauthorized
  }

  var id = req.params.id || '';
  if (id === '') {
    return res.sendStatus(400); // Bad Request
  }

  var query = db.postModel.findOne({ _id: id, user_id: req.user.id });
  query.select('_id title tags type content created updated public');
  query.exec(function(err, result) {

    if (err) {
        console.log(err);
        return res.sendStatus(400); // Bad Request
    }

    if (result != null) {
      result.update({ $inc: { read: 1 } }, function(err, nbRows, raw) {
        return res.status(200).json(result);
      });
    }
    else {
      return res.sendStatus(400); // Bad Request
    }

  });
}; 

exports.create = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var post = req.body.post;
  if (post == null) {
    return res.sendStatus(400); // Bad Request
  }

  var postEntry = new db.postModel();

  postEntry.user_id = req.user.id;
  postEntry.title = post.title;
  postEntry.public = post.public;
  postEntry.content = post.content;
  postEntry.type = post.type;

  // Tags are comma separated
  if (post.tags != null) {
    if (Object.prototype.toString.call(post.tags) === '[object Array]') {
      postEntry.tags = post.tags;
    }
    else {
      postEntry.tags = post.tags.split(',');
    }
  }

  postEntry.save(function(err) {
    if (err) {
      return res.sendStatus(400); // Bad Request
    }

    return res.status(200).send('Created post successfull');

  });
}

exports.update = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Not authorized
  }

  var post = req.body.post;
  if (post == null) {
    res.sendStatus(400); // Bad request
  }

  var updatePost = {};

  // Title required
  if (post.title !== null && post.title !== "" && post.title !== undefined) {
    updatePost.title = post.title;
  }

  // Convert commaseparate tags to objects.
  if (post.tags != null) {
    if (Object.prototype.toString.call(post.tags) === '[object Array]') {
      updatePost.tags = post.tags;
    }
    else {
      updatePost.tags = post.tags.split(',');
    }
  }

  if (post.type != null) {
    updatePost.type = post.type;
  }

  if (post.public != null) {
    updatePost.public = post.public;
  }

  if (post.content != null && post.content != "") {
    updatePost.content = post.content;
  }

  updatePost.updated = new Date();

  db.postModel.update({_id: post._id, user_id: req.user.id}, updatePost, function(err, nbRows, raw){});

  // Make a version after each update
  var postVersionEntry = new db.postVersionModel({org_id: true});
  postVersionEntry.user_id = req.user.id;
  postVersionEntry.org_id = post._id;
  var version = Object.keys(updatePost); 
  version.forEach(function(entry) {
    postVersionEntry[entry] = updatePost[entry]; 
  });
  postVersionEntry.save(function(err) {
    if (err) {
      return res.sendStatus(400); // Bad Request
    }
    return res.status(200).send('Updated post successfull'); 
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

  var query = db.postModel.findOne({_id:id});

  query.exec(function(err, result) {
    if (err) {
      console.log(err);
      return res.sendStatus(400); // Bad request
    }

    if (result != null) {
      result.remove();
      return res.status(200).send('Deleted post successfull');
      console.log('Post deleted successfull -> User: ' + req.user.id + ' -> contact_id' + id); 
    }
    else {
      return res.sendStatus(404); // Not Found
    }

  });
};

exports.pdf = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  if (!req.params.id) {
    return res.sendStatus(400); // Bad Request
  }

  var query = db.postModel.findOne({ _id: req.params.id, user_id: req.user.id });
  query.select('_id title tags type content created updated public');
  query.exec(function(err, result) {

    if (err) {
        console.log(err);
        return res.sendStatus(400); // Bad Request
    }

    if (result != null) {

      var options = { 
        cssPath: './config/pdf.css',
      }

      var pathToPdf = './tmp/pdf/' + result._id;
      var body = '# ' + result.title + '\n\n' + result.content;
      markdownpdf(options).from.string(body).to(pathToPdf, function () {
        console.log("Created -> ", pathToPdf)
        res.download(pathToPdf); 
      })

    }

  });
}; 

exports.listByTag = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var tagName = req.params.tagName || '';
  if (tagName == '') {
    return res.sendStatus(400);
  }

  var query = db.postModel.find({tags: tagName, public: true, user_id: req.user.id });
  query.select('_id title tags type created updated public');
  query.sort('-created');
  query.exec(function(err, results) {
    if (err) {
      console.log(err);
      return res.sendStatus(400);
    }

    for (var postKey in results) {
      results[postKey].content = results[postKey].content.substr(0, 400);
    }

    return res.status(200).json(result);
  });
}

exports.listVersions = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  var query = db.postVersionModel.find({user_id: req.user.id, org_id: req.params.id});

  query.select("_id title type created");
  query.sort('-updated');
  query.exec(function(err, results) {

    if (err) {
      console.log(err);
      return res.sendStatus(400); // Bad Request
    }

    if (results !== null) {
      return res.status(200).json(results); // OK
    } else {
      return res.sendStatus(404); // Not Found
    }

  });

};

exports.readVersion = function(req, res) {

  if (!req.user) {
    return res.sendStatus(401); // Unauthorized
  }

  if (!req.params.id === '') {
    return res.sendStatus(400); // Bad Request
  }

  var query = db.postVersionModel.findOne({ _id: req.params.id, user_id: req.user.id });
  query.exec(function(err, result) {

    if (err) {
        console.log(err);
        return res.sendStatus(400); // Bad Request
    }

    if (result != null) {
      result.update({ $inc: { read: 1 } }, function(err, nbRows, raw) {
        return res.status(200).json(result);
      });
    }
    else {
      return res.sendStatus(400); // Bad Request
    }

  });
}; 

