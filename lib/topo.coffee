class Topo
  constructor: (@socket) ->
    @routes = []
    @socket.on( "connect", =>
      @socket.on( "message", @_handleMessage )
    )
    this

  route: (route, callback) ->
    if typeof route == "object"
      for _route, _callback of route
        continue unless route.hasOwnProperty( _route )
        this._register( _route, _callback )
    else
      this._register( route, callback )
    this

  _register: (route, callback) ->
    regex = "^" + route.split( /[A-Z][A-Z_]+/ ).join( "([^\/]+)" ) + "/?$"
    @routes[regex] = callback
    null

  _handleMessage: (msg) ->
    return unless msg instanceof Array
    return unless typeof msg[0] == "string"
    [route, data] = msg
    for regex, callback of @routes
      if args = route.match( regex )
        args.shift()
        args.push( data )
        callback.apply( null, args )
    null
