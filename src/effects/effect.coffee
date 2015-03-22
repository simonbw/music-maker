Mixer = require '../mixer.coffee'
Util = require "../util.coffee"

# Base class for audio effects
class Effect
  constructor: () ->
    @input = Mixer.context.createGain()
    @output = Mixer.context.createGain()
    @wet = Mixer.context.createGain()
    @dry = Mixer.context.createGain()
    @input.connect(@wet)
    @input.connect(@dry)
    @dry.connect(@output)

    @setWet(1.0)
    
  setWet: (value) ->
    value = Util.clamp(value)
    @dry.gain.value = 1.0 - value
    @wet.gain.value = value

  connect: (args...) ->
    @output.connect(args...)
    
module.exports = Effect