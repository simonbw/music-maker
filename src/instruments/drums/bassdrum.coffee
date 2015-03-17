Mixer = require "../../mixer.coffee"
BufferInstrument = require "../buffer_instrument.coffee"
Util = require "../../util.coffee"

class BassDrum extends BufferInstrument
  
  PARTIALS = [{
      frequency: 15 + 37,
      volume: 0.5,
      decay: 1.0
    }, {
      frequency: 15 + 47,
      volume: 0.5,
      decay: 1.3
    }, {
      frequency: 15 + 61,
      volume: 0.9,
      decay: 1.7
    }, {
      frequency: 15 + 83,
      volume: 1.2,
      decay: 2.2
    }, {
      frequency: 15 + 147,
      volume: 1.1,
      decay: 2.8
    }, {
      frequency: 15 + 221,
      volume: 0.6,
      decay: 3.5
    }, {
      frequency: 15 + 347,
      volume: 1.6,
      decay: 3.5
    }, {
      frequency: 15 + 484,
      volume: 0.6,
      decay: 3.5
    }]

  constructor: (gain) ->
    super(gain)

    @filter = Mixer.context.createBiquadFilter()
    @filter.type = 'lowpass'
    @filter.frequency.value = 2000
    @filter.Q.value = 1.0
    @filter.connect(@output)

    @chainStart = @filter

  writeToBuffer: (note, beat, buffer) ->
    for sample, i in buffer
      decay = i / buffer.length
      decay = Math.pow(decay, 0.4)
      phase = i / Mixer.context.sampleRate * Math.PI
      d = Util.partialsWithDecay(PARTIALS, phase, decay) * note.attack
      buffer[i] = d

  getBufferLength: (note, beat) ->
    return Math.ceil(0.7 * Mixer.context.sampleRate * Math.sqrt(note.attack))

module.exports = BassDrum
