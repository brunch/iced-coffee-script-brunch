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
  generators:
    backbone:
      model: (name) ->
        """module.exports = class #{formatClassName name} extends Backbone.Model"""

      view: (name) ->
        """template = require 'views/templates/#{name}'

module.exports = class #{formatClassName name}View extends Backbone.View
  template: template
"""

    chaplin:
      controller: (name) ->
        """Controller = require 'controllers/controller'
#{formatClassName name} = 'models/#{name}'
#{formatClassName name}View = require 'views/#{name}'

module.exports = class #{formatClassName name}Controller extends Controller
  historyURL: ''
"""
      model: (name) ->
        """Model = require 'models/model'

module.exports = class #{formatClassName name} extends Model
"""

      view: (name) ->
        """View = require 'views/view'
template = require 'views/templates/#{name}'

module.exports = class #{formatClassName name}View extends View
  template: template
"""

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
