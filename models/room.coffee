fixBuffers = (o) ->
  Object.keys(o).forEach (e) ->
    o[e] = o[e].toString()
  return o

module.exports = (models) ->
    redis = models.redis

    keyify = (args...) -> ['lolgebra', args...].join(':')

    message_key = (id) -> keyify('messages', id)
    messages_id_key = keyify('messages', '__id__')

    models.Room = class Room
        pubSubKey: -> keyify('rooms', @name, 'pubsub')
        messagesKey: -> keyify('rooms', @name, 'messages')

        constructor: (name) ->
            @name = name

        getMessages: (start, end, cb) ->
            redis.lrange @messagesKey(), start, end, (err, message_ids) ->
              throw err if err

              return cb(null, []) unless message_ids

              count = 0
              received_messages = []
              message_ids.forEach (id) ->
                redis.hgetall message_key(id), (err, message) ->
                  console.log inspect(received_messages)
                  return cb(err) if err

                  count += 1
                  received_messages[+id] = fixBuffers(message)
                  if count == message_ids.length
                    cb(null, received_messages.filter((e)->e))

        post: (message, cb) ->
          redis.incr messages_id_key, (err, id) =>
            try
              return cb(err) if err
              args = []

              console.log inspect(message)
              Object.keys(message).forEach (key) ->
                args[args.length] = key
                args[args.length] = message[key]

              console.log inspect(args)
            catch e
              cb(e)

            redis.rpush @messagesKey(), id

            redis.hmset message_key(+id), args..., (err, data) ->
                return cb(err) if err
                cb(null, data)
