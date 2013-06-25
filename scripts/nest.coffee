# Description:
#   Interact with Nest Thermestats.
#
# Dependencies:
#   "unofficial-nest-api": ">= 0.1.4"
#
# Configuration:
#  HUBOT_NEST_USERNAME
#  HUBOT_NEST_PASSWORD
#
# Commands:
#   hubot what is the air set to? - Returns the current thermostat setting

nest = require('unofficial-nest-api')
util = require 'util'

getTemperature = (username, password, msg, callback) ->
  nest.login username, password, (error, data) ->
    if error
      msg.send "Error talking to Nest: #{err.message}"
      return

    nest.fetchStatus (data) ->
      target_temperature = data.shared[Object.keys(data.shared)[0]].target_temperature
      callback(nest.ctof(target_temperature))

ensureAuth = (auth, msg, callback) ->
    unless auth.username
      msg.send "Please set the HUBOT_NEST_USERNAME variable"
      return
    unless auth.password
      msg.send "Please set the HUBOT_NEST_PASSWORD variable"
      return
    callback()



module.exports = (robot) ->
  auth =
    username: process.env.HUBOT_NEST_USERNAME
    password: process.env.HUBOT_NEST_PASSWORD

  robot.respond /what is the air( set to\?)?/i, (msg) ->
    ensureAuth auth, msg, ->
      getTemperature auth.username, auth.password, msg, (temp) ->
        msg.send "#{temp} degrees"

