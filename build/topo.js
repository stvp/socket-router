(function() {
  var Topo;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Topo = (function() {
    function Topo(socket) {
      this.socket = socket;
      this.routes = [];
      this.socket.on("connect", __bind(function() {
        return this.socket.on("message", this._handleMessage);
      }, this));
      this;
    }
    Topo.prototype.route = function(route, callback) {
      var _callback, _route;
      if (typeof route === "object") {
        for (_route in route) {
          _callback = route[_route];
          if (!route.hasOwnProperty(_route)) {
            continue;
          }
          this._register(_route, _callback);
        }
      } else {
        this._register(route, callback);
      }
      return this;
    };
    Topo.prototype._register = function(route, callback) {
      var regex;
      regex = "^" + route.split(/[A-Z][A-Z_]+/).join("([^\/]+)") + "/?$";
      this.routes[regex] = callback;
      return null;
    };
    Topo.prototype._handleMessage = function(msg) {
      var args, callback, data, regex, route, _ref;
      if (!(msg instanceof Array)) {
        return;
      }
      if (typeof msg[0] !== "string") {
        return;
      }
      route = msg[0], data = msg[1];
      _ref = this.routes;
      for (regex in _ref) {
        callback = _ref[regex];
        if (args = route.match(regex)) {
          args.shift();
          args.push(data);
          callback.apply(null, args);
        }
      }
      return null;
    };
    return Topo;
  })();
}).call(this);
