topo.js
=======

Extends socket.io's handling of event names to allow routes that can capture params. For example:

```coffee
socket = io.connect( "http://localhost/" )
socket.on( "connect", ->
  socket.on( "/users/USER_ID/signed_in", (userId, data) ->
    user = User.get( userId )
    console.log( "#{user.name} has signed in at #{data.timestamp}" )
  )
)
```

Then, on the server side, you can run something like:

```coffee
io = require( "socket.io" ).listen( 80 )
io.sockets.on( "connection", (socket) ->
  socket.emit( "/users/1234/signed_in", timestamp: "Mon, Jan 4 2008 @ 5:20pm" )
});
```

"Routes" are differentiated from event names by the use of the forward slash as the first character (as in an absolute href).

Usage
=====

All you need to do is include `topo.js` after you load `socket.io`:

```html
<script src="/socket.io/socket.io.js"></script>
<script src="/topo.js"></script>
```

Then use routes as your event names.
