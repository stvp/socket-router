topo.js
=======

Topo.js is a simple client-side router for [socket.io](http://socket.io). Topo will listen on the given WebSocket for messages of the form:

    ["/some/route", { foo: "bar" }]

And call any callback functions listening to the route.

Routes can capture params in the following way:

    "/users/USER_ID/signed_in"

Which will be translated to the RegExp:

    ^\/users\/([^\/]+)\/signed_in\/?$

Routes can capture any number of params. These captured params will be appended to the callback's arguments.

Usage
-----

```coffee
# Connect to the WebSocket
socket = io.connect( "http://localhost/socket" )

# Create a new router with the socket connection
router = new Topo( socket )

# Add routes
router.route( "/users/USER_ID/typing", (userId, data) ->
  User.get( userId ).markTyping( true )
)

router.route({
  "/users/USER_ID/signed_in": (userId, data) ->
    User.get( userId ).setStatus( "active" )

  "/users/USER_ID/signed_out": (userId, data) ->
    User.get( userId ).setStatus( "inactive" )

  "/users/USER_ID/chat/ROOM_ID": (userId, roomId, data) ->
    user = User.get( userId )
    Room.get( ROOM_ID ).say( user, data.message )
})
```
