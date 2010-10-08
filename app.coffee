Express = require 'express'
Eco = require 'eco'
helpers = require './helpers'

app = Express.createServer(
  Express.bodyDecoder()
  Express.logger()
  Express.staticProvider(__dirname + '/public')
)

app.register '.eco'
  render: (template, options) ->
    Eco.render template, options.locals

app.configure 'development', ->

require('./models')(app)

app.get '/', (req, res) ->
    res.send('Hello, World!')

app.helpers(helpers.static)
app.dynamicHelpers(helpers.dynamic)

app.get '/chat/:room', (req, res) ->
    res.render 'chat.eco',
      locals:
        room: req.params.room
        user: (req.params.user || '')

require('./messages')(app)

app.listen(3000)
