express = require('express')
connect = require('connect')

app = module.exports = express.createServer()

# Config

app.configure ->
    app.set 'views', __dirname + '/views'

    # middleware stack!
    app.use connect.bodyDecoder()
    app.use connect.methodOverride()
    app.use app.router

app.configure 'development', ->
    app.use connect.staticProvider(__dirname + '/public')
    app.use connect.errorHandler(dumpExceptions: true, showStack: true)

# Routes

app.get '/', (req, res) ->
    res.render 'index.html.ejs'
        locals:
            title: 'Express'

app.post '/chat/:room', (req, res) ->
    roomName = req.param('room').toLowerCase()
    userName = req.param('name') || req.cookies.username

FayeAdapter = require('faye').NodeAdapter
new FayeAdapter(mount: '/faye', timeout: 45).attach(app)

app.listen 3000 unless module.parent
