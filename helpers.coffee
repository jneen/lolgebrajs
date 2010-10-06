QS = require('querystring')

Array::uniq = (fn) ->
    seen = {}
    @filter (el) ->
        key = if typeof fn is 'function' then fn(el) else el
        r = !seen[key]
        seen[key] = yes
        return r

exports.dynamic =
  addExternal: (req, res) ->
    externals = (res.externals ?= {})
    (type, contents...) ->
      externals[type] ?= {}
      contents.forEach (content) ->
        externals[type][content] = true

  renderExternal: (req, res) ->
    externals = (res.externals ?= {})
    (type, mapper) ->
      toRender = Object.keys(externals[type] || {})
      if typeof mapper is 'function'
        @safe toRender.map(mapper).join("\n")
      else
        @safe toRender

exports.static =
  js: (paths...) ->
      @addExternal('javascripts', paths...)

  css: (paths...) ->
      @addExternal('stylesheets', paths...)

  renderJS: ->
      @renderExternal 'javascripts', (js) =>
        "<script type='text/javascript' src='#{@safe(js)}'></script>"

  renderCSS: ->
      @renderExternal 'stylesheets', (css) =>
        "<link rel='stylesheet' href='#{@safe(css)}'>"

  routes:
      chat:
        path: (room, params) ->
            if typeof room is 'object'
              params = room
              name = params.room
              delete params.room

            if typeof params is 'object'
              params = QS.stringify(params)

            if params
              "/chat/#{room}?#{params}"
            else
              "/chat/#{room}"
