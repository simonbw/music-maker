Mixer = require "../../mixer.coffee"
BufferInstrument = require "../buffer_instrument.coffee"
Util = require "../../util.coffee"

class SnareDrum extends BufferInstrument

  PARTIALS = [{
      frequency: 7.7 * Math.pow(15 + 37, 0.85),
      volume: 0.5,
      decay: 1.0
    }, {
      frequency: 7.7 * Math.pow(15 + 47, 0.85),
      volume: 0.5,
      decay: 1.3
    }, {
      frequency: 7.7 * Math.pow(15 + 61, 0.85),
      volume: 0.9,
      decay: 1.7
    }, {
      frequency: 7.7 * Math.pow(15 + 83, 0.85),
      volume: 1.2,
      decay: 2.2
    }, {
      frequency: 7.7 * Math.pow(15 + 147, 0.85),
      volume: 0.9,
      decay: 2.8
    }, {
      frequency: 7.7 * Math.pow(15 + 221, 0.85),
      volume: 0.6,
      decay: 3.5
    }, {
      frequency: 7.7 * Math.pow(15 + 347, 0.85),
      volume: 0.6,
      decay: 4.3
    }, {
      frequency: 7.7 * Math.pow(15 + 484, 0.85),
      volume: 0.6,
      decay: 5.4
    }]

  constructor: (gain) ->
    super(gain)

    @filter = Mixer.context.createBiquadFilter()
    @filter.type = 'lowpass'
    @filter.frequency.value = 8000
    @filter.Q.value = 2.5
    @filter.connect(@output)

    @chainStart = @filter

  writeToBuffer: (note, beat, buffer) ->
    for sample, i in buffer
      decay = i / buffer.length
      decay = Math.pow(decay, 0.4)
      phase = i / Mixer.context.sampleRate * Math.PI
      d = Util.partialsWithDecay(PARTIALS, phase, decay) * 0.3 * note.attack * note.attack
      d += (Math.random() * 2 - 1) * (1 - decay) * 0.4 * note.attack * note.attack # the snare
      buffer[i] = d

  getBufferLength: (note, beat) ->
    return 0.3 * Math.sqrt(note.attack)
    
module.exports = SnareDrum
