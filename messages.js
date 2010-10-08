(function() {
  var IO, inspect;
  IO = require('socket.io');
  inspect = require('sys').inspect;
  module.exports = function(app) {
    var clients, socket;
    app.get('/chat/:room/messages', function(req, res) {
      var first, last, room;
      room = new app.models.Room(req.params.room);
      first = +(req.params.start = (typeof req.params.start !== "undefined" && req.params.start !== null) ? req.params.start : (-10));
      last = +(req.params.end = (typeof req.params.end !== "undefined" && req.params.end !== null) ? req.params.end : (-1));
      return room.getMessages(first, last, function(err, messages) {
        if (err) {
          throw err;
        }
        return res.send({
          status: 1,
          messages: messages,
          lastId: 20
        });
      });
    });
    app.post('/chat/:room/message', function(req, res) {
      var room;
      room = new app.models.Room(req.param('room'));
      return room.post(req.param('message'), function(err, data) {
        if (err) {
          throw err;
        }
        return res.send({
          data: data
        });
      });
    });
    socket = IO.listen(app, {
      transports: ['websocket', 'htmlfile', 'xhr-multipart', 'xhr-polling', 'jsonp-polling']
    });
    clients = {};
    return socket.on('connection', function(client) {
      console.log('client connected', inspect(client));
      return client.on('message', function(msg) {
        if (msg.type === 'join') {
          clients[msg.room] || (clients[msg.room] = {});
          return client.send({
            name: 'me',
            message: 'W00T'
          });
        }
      });
    });
  };
}).call(this);
