Mixer = require "../mixer.coffee"
Util = require "../util.coffee"
Effect = require "./effect.coffee"

class SimpleReverb extends Effect
  constructor: (amount = 0.7, length) ->
    super()
    @input = Mixer.context.createGain()
    @wet = Mixer.context.createGain()
    @dry = Mixer.context.createGain()
    @convolver = Mixer.context.createConvolver()

    # dry path
    @input.connect(@dry)
    @dry.connect(@output)
    # wet path
    @input.connect(@wet)
    @wet.connect(@convolver)
    @convolver.connect(@output)

    @setLength(length)
    @setAmount(amount)

  setLength: (length) ->
    buffer = Mixer.getBuffer(length)
    impulse = buffer.getChannelData(0)
    for i in [0...impulse.length]
      impulse[i] = Math.random() * Math.pow(1 - i / impulse.length, 1.6)
    @convolver.buffer = buffer

  setAmount: (value) ->
    value = Util.clamp(value)
    @dry.gain.value = 1.0 - value
    @wet.gain.value = value

module.exports = SimpleReverb