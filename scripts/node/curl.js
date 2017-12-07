//---------------------------------------------
// https://www.npmjs.com/package/node-curl
//---------------------------------------------
//
// Curl example to get the title from a website
//---------------------------------------------
//
// Add this line in the `/api.js`
//---------------------------------------------
//app.put('/curl', routes.curl.meta); 
//
// curl 'http://test.filmer.net:3001/curl' -X PUT -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"curl":{"url":"https://maketime.nl/"}}' --compressed
//
// This code belongs in `/routes/curl.js`
//
//#############################################

curl = require('node-curl');

exports.meta = function(req, res) {

  var url = req.body.curl.url;

  curl(url, function(err) {
    console.info(this.status);
    console.info('-----');
    console.info(this.header);
    console.info('-----');
    console.info(this.info('SIZE_DOWNLOAD'));

    var title = /(<\s*title[^>]*>(.+?)<\s*\/\s*title)>/gi;
    var str = this.body.toString();
    var match = title.exec(str);
    if (match && match[2]) {
      return res.send(match[2]); 
      console.log(match[2]);
    }

  });

};

