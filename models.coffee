Redis = require 'redis'

module.exports = (app) ->
  app.models = {}

  #TODO: configure by env
  app.models.redis = Redis.createClient()
  require('./models/room')(app.models)
