redis = require('redis-client').createServer()

module.exports =
  Room: require('./models/room')(redis)
  OtherModel: require('./models/other_model')(redis)
