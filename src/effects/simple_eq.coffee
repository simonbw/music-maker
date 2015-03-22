Mixer = require "../mixer.coffee"
Util = require "../util.coffee"
Effect = require "./effect.coffee"

# A simple equalizer with 3 bands
class SimpleEQ extends Effect
  constructor: (low = 0, mid = 0, high = 0) ->
    super()
    @low = Mixer.context.createBiquadFilter()
    @mid = Mixer.context.createBiquadFilter()
    @high = Mixer.context.createBiquadFilter()

    @low.type = 'lowshelf'
    @low.frequency.value = 200
    @low.Q.value = 0.6

    @mid.type = 'peaking'
    @mid.frequency.value = 1000
    @mid.Q.value = 0.5
    
    @high.type = 'highshelf'
    @high.frequency.value = 6000
    @high.Q.value = 0.6

    @setLevels(low, mid, high)

    Util.connectAll(@wet, @low, @mid, @high, @output)

  setLevels: (low, mid, high) ->
    if low? then @low.gain.value = low
    if mid? then @mid.gain.value = mid
    if high? then @high.gain.value = high

module.exports = SimpleEQ