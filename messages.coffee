inspect = require('sys').inspect

module.exports = (app) ->
  # get a slice of the room's messages
  app.get '/chat/:room/messages', (req, res) ->
    console.log "/chat/:room/messages #{inspect(req.params)}"
    room = new app.models.Room(req.params.room)
    first = +(req.params.start ?= -10)
    last  = +(req.params.end   ?=  -1)
    room.getMessages first, last, (err, messages) ->
      console.log 'messages', inspect(messages)
      throw err if err
      res.send
          status: 1
          messages: messages
          lastId: 20

  # post a message to the room
  app.post '/chat/:room/message', (req, res) ->
    room = new app.models.Room(req.params.room)
    room.post req.param('message'), (err, data) ->
      throw err if err
      res.send({data: data})

  # add a client to the room
  socket = IO.listen(app)

  clients = {}
  socket.on 'connection', (client) ->
      console.log(inspect(client))
      client.on 'message', (msg) ->
          if msg.type is 'init'
              clients[msg.room] ||= {}
              client.send(name: 'me', message: 'W00T')

