Mixer = require "../mixer.coffee"
OscillatorInstrument = require "./oscillator_instrument.coffee"

class SineSynth extends OscillatorInstrument
  constructor: (gain) ->
    super(gain, 'sine')

module.exports = SineSynth