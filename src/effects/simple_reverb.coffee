Mixer = require "../mixer.coffee"
Util = require "../util.coffee"
Effect = require "./effect.coffee"

class SimpleReverb extends Effect
  constructor: (wet = 0.7, length = 1.0) ->
    super()
    
    @convolver = Mixer.context.createConvolver()
    @convolver.normalize = true

    Util.connectAll(@wet, @convolver, @output)

    @setLength(length)
    @setWet(wet)

  setLength: (length) ->
    buffer = Mixer.getBuffer(length)
    impulse = buffer.getChannelData(0)
    value = 0
    for i in [0...impulse.length]
      smoothing = 0.3 + (i / impulse.length) * 0.65
      r = Random.uniform(-1, 1) * Math.pow(1 - i / impulse.length, 1.6)
      value = smoothing * value + (smoothing - 1) * r
      impulse[i] = value
    @convolver.buffer = buffer

module.exports = SimpleReverb