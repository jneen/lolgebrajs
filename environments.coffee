# environment-specific configurations
module.exports = (Connect) ->
    development: (req, res, next) ->
        next()

    production: (req, res, next) ->
        next()

    test: (req, res, next) ->
        next()
