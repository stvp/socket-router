# This is a quick demo of topo.js. See README.markdown for more info.

io = require( "socket.io" )
express = require( "express" )

app = express.createServer()
io = io.listen( app )

app.listen( 4000 )

# Static files
app.use( express.static( __dirname + "/../" ) )
app.get( "/", (req, res) -> res.sendfile( __dirname + "/index.html" ) )

# Socket stuff
io.sockets.on( 'connection', (socket) ->
  socket.emit( '/users/1234/typing', { hello: 'world' } )
  socket.emit( '/users/5678/typing', { hello: 'world' } )
)
