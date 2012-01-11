(function() {
  var buildRegex;

  buildRegex = function(route) {
    return new RegExp("^" + route.split(/[A-Z][A-Z_]+/).join("([^/]+)") + "/?$");
  };

  io.SocketNamespace.prototype._on = io.SocketNamespace.prototype.on;

  io.SocketNamespace.prototype.on = function(name, fn) {
    var regex;
    if (!this.$routes) this.$routes = {};
    if (name[0] === "/") {
      regex = buildRegex(name);
      if (this.$routes[regex]) {
        this.$routes[regex].callbacks.push(fn);
      } else {
        this.$routes[regex] = {
          regexp: regex,
          callbacks: [fn]
        };
      }
    }
    return this._on.apply(null, arguments);
  };

  io.SocketNamespace.prototype._emit = io.SocketNamespace.prototype.$emit;

  io.SocketNamespace.prototype.$emit = function(name) {
    var args, callback, regexpStr, route, _i, _len, _ref, _ref2;
    if (name[0] === "/" && this.$routes) {
      _ref = this.$routes;
      for (regexpStr in _ref) {
        route = _ref[regexpStr];
        if (args = name.match(route.regexp)) {
          args.shift();
          args = args.concat(Array.prototype.slice.call(arguments, 1));
          _ref2 = route.callbacks;
          for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
            callback = _ref2[_i];
            callback.apply(null, args);
          }
        }
      }
    }
    return this._emit.apply(null, arguments);
  };

}).call(this);
