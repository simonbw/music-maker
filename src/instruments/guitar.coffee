Mixer = require "../mixer.coffee"
BufferInstrument = require "./buffer_instrument.coffee"

class Guitar extends BufferInstrument

  writeToBuffer: (note, buffer) ->
    # fill buffer
    N = Math.floor(2 * Mixer.context.sampleRate / note.frequency)

    for i in [0...N]
      buffer[i] = Math.random() * 2 - 1

    # do the rest of it
    for i in [N...buffer.length]
      buffer[i] = (buffer[i - N] + buffer[i - N + 1]) / 2

module.exports = Guitar
