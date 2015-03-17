Mixer = require "../mixer.coffee"
OscillatorInstrument = require "./oscillator_instrument.coffee"

class TriangleSynth extends OscillatorInstrument
  constructor: (gain) ->
    super(gain, 'triangle')

module.exports = TriangleSynth
