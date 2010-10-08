IO = require('socket.io')
inspect = require('sys').inspect

module.exports = (app) ->
  # get a slice of the room's messages
  app.get '/chat/:room/messages', (req, res) ->
    room = new app.models.Room(req.params.room)
    first = +(req.params.start ?= -10)
    last  = +(req.params.end   ?=  -1)
    room.getMessages first, last, (err, messages) ->
      throw err if err
      res.send
          status: 1
          messages: messages
          lastId: 20

  # post a message to the room
  app.post '/chat/:room/message', (req, res) ->
    room = new app.models.Room(req.param('room'))
    room.post req.param('message'), (err, data) ->
      throw err if err
      res.send({data: data})

  # add a client to the room
  socket = IO.listen app,
    transports: ['websocket', 'htmlfile', 'xhr-multipart', 'xhr-polling', 'jsonp-polling']

  clients = {}
  socket.on 'connection', (client) ->
      console.log('client connected', inspect(client))
      client.on 'message', (msg) ->
          if msg.type is 'join'
              clients[msg.room] ||= {}
              client.send(name: 'me', message: 'W00T')

