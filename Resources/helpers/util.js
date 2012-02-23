var exports;
exports = {
  mix: function() {
    var arg, child, prop, _i, _len;
    child = {};
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      arg = arguments[_i];
      for (prop in arg) {
        if (arg.hasOwnProperty(prop)) {
          child[prop] = arg[prop];
        }
      }
    }
    return child;
  }
};