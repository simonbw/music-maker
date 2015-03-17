Mixer = require "../mixer.coffee"
OscillatorInstrument = require "./oscillator_instrument.coffee"

class SawtoothSynth extends OscillatorInstrument
  constructor: (gain) ->
    super(gain, 'sawtooth')

module.exports = SawtoothSynth
