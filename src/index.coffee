iced = require 'iced-coffee-script'
sysPath = require 'path'

module.exports = class IcedCoffeeScriptCompiler
  brunchPlugin: yes
  type: 'javascript'

  constructor: (@config) ->
    cfg = @config.plugins?.icedCoffeeScript ? {}
    @extension = cfg.extension ? 'iced'
    null

  compile: (data, path, callback) ->
    try
      result = iced.compile data
    catch err
      error = err
    finally
      callback error, result

  include: ->
    [sysPath.join __dirname, '..', 'vendor', 'iced-coffee-script.js']
