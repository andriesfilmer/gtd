var fs = require('fs');

// Recursive creation of dirs.
exports.mkdir = function (path, root) {

  var dirs = path.split('/'), dir = dirs.shift(), root = (root || '') + dir + '/';

  try { fs.mkdirSync(root); }
  catch (e) {
    //dir wasn't made, something went wrong
    if(!fs.statSync(root).isDirectory()) throw new Error(e);
  }

  return !dirs.length || this.mkdir(dirs.join('/'), root);

}

