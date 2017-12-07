var fs = require('fs');
var toc = require('markdown-toc');

var args = process.argv.slice(2);

if (args != '') {
  var readme = fs.readFileSync(args.toString()).toString();
  var results = toc(readme).content;
  console.log(results);
}
else {
  console.log("Usage: node readme-add-toc.js path_to_file");
}

function render(str, options) {
  return new Remarkable()
    .use(toc.plugin(options)) // <= register the plugin
    .render(str);
}

