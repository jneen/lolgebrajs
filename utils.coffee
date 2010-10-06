responseProto =
    responseProtoSet: true
    simpleResponse: (content, type, cb) ->
        type ||= 'text/html'
        @writeHead(200, {'Content-Type': type})
        @write(content)
        if cb
            cb()
        else
            @end()

    text: (content, cb) ->
        @simpleResponse(content, 'text/plain', cb)

    html: (content, cb) ->
        @simpleResponse(content, 'text/html', cb)

    json: (content, cb) ->
        if typeof content is 'object'
            content = JSON.stringify(content)
        @simpleResponse(content, 'text/json', cb)

module.exports = (req, res, next) ->
    unless res.responseProtoSet
        responseProto.__proto__ = res.__proto__
        res.__proto__ = responseProto

    next()
