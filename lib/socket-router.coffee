# TODO: Check for namespace conflicts

# Given a route string, build a RegExp that will match it and capture any
# CAPS_AND_UNDERSCORE pieces. Eg.
#
#     "/users/USER_ID/typing"
#
# Becomes:
#
#     /^\/users\/([^\/]+)\/typing\/?$/
#
buildRegex = (route) ->
  new RegExp( "^" + route.split( /[A-Z][A-Z_]+/ ).join( "([^/]+)" ) + "/?$" )

# ==============
# = io.on(...) =
# ==============

# Monkey patch io.on() to look for route-style names.
io.SocketNamespace.prototype._on = io.SocketNamespace.prototype.on

io.SocketNamespace.prototype.on = (name, fn) ->
  @$routes = {} unless @$routes
  # If the name looks like a route, add it to the routes object.
  #
  # NOTE: You can't use RegExps as object keys -- JavaScript will convert
  # it to a string before making it a key. So that's the magic here.
  if name[0] == "/"
    regex = buildRegex( name )
    if @$routes[regex]
      @$routes[regex].callbacks.push( fn )
    else
      @$routes[regex] = {
        regexp: regex
        callbacks: [fn]
      }

  # Resume as normal
  return this._on.apply( null, arguments )

# ==============
# = io.$emit() =
# ==============

# Monkey patch the $emit method, which handles all incomming messages.
io.SocketNamespace.prototype._emit = io.SocketNamespace.prototype.$emit

io.SocketNamespace.prototype.$emit = (name) ->
  if name[0] == "/" && @$routes
    for regexpStr, route of @$routes
      if args = name.match( route.regexp )
        args.shift() # Lose the raw route
        # Add the message payload
        args = args.concat( Array.prototype.slice.call( arguments, 1 ) )
        for callback in route.callbacks
          callback.apply( null, args )

  # Resume as normal
  return this._emit.apply( null, arguments )
