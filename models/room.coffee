module.exports = (redis) ->
    keyify = -> ['lolgebra', Array.slice.call(arguments)...].join(':')

    name_key = (name) -> keyify('room', 'by_name', name)

    messages_key = (room_name) -> keyify('rooms', room_name, 'messages')

    message_key = (id) -> keyify('messages', id)

    class Room
        constructor: (name) ->
            @name = name

        getMessages: (start, end, cb) ->
            redis.lrange messages_key(@name), start, end, (err, message_ids) ->
                count = 0
                received_messages = []
                message_ids.each (id) ->
                    redis.hgetall message_key(id), (message) ->
                        count += 1
                        received_messages[+id] = message
                        if count == message_ids.length
                            cb(received_messages)
