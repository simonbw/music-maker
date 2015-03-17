Mixer = require "../mixer.coffee"
OscillatorInstrument = require "./oscillator_instrument.coffee"

class SquareSynth extends OscillatorInstrument
  constructor: (gain) ->
    super(gain, 'square')

module.exports = SquareSynth
