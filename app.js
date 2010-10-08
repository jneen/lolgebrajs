(function() {
  var Eco, Express, app, helpers;
  Express = require('express');
  Eco = require('eco');
  helpers = require('./helpers');
  app = Express.createServer(Express.bodyDecoder(), Express.logger(), Express.staticProvider(__dirname + '/public'));
  app.register('.eco', {
    render: function(template, options) {
      return Eco.render(template, options.locals);
    }
  });
  app.configure('development', function() {});
  require('./models')(app);
  app.get('/', function(req, res) {
    return res.send('Hello, World!');
  });
  app.helpers(helpers.static);
  app.dynamicHelpers(helpers.dynamic);
  app.get('/chat/:room', function(req, res) {
    return res.render('chat.eco', {
      locals: {
        room: req.params.room,
        user: (req.params.user || '')
      }
    });
  });
  require('./messages')(app);
  app.listen(3000);
}).call(this);
