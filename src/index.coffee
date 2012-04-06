iced = require 'iced-coffee-script'
sysPath = require 'path'

# Example
# 
#   capitalize 'test'
#   # => 'Test'
#
capitalize = (string) ->
  (string[0] or '').toUpperCase() + string[1..]

# Example
# 
#   formatClassName 'twitter_users'
#   # => 'TwitterUsers'
#
formatClassName = (filename) ->
  filename.split('_').map(capitalize).join('')

module.exports = class IcedCoffeeScriptCompiler
  brunchPlugin: yes
  type: 'javascript'
  extension: 'iced'
  generators:
    backbone: do ->
      types = {}
      ['collection', 'model', 'router', 'view'].forEach (type) ->
        parent = formatClassName type
        types[type] = (fileName) ->
          className = formatClassName fileName
          "class exports.#{className} extends Backbone.#{parent}\n"
      types

  constructor: (@config) ->
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
