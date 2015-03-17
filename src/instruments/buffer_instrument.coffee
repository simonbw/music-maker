Mixer = require "../mixer.coffee"
Instrument = require "./instrument.coffee"

# Base class for instruments that fill a buffer on their own
class BufferInstrument extends Instrument
  # Play a note
  play: (note, beat) ->
    buffer = Mixer.context.createBuffer(1, @getBufferLength(note, beat), Mixer.context.sampleRate)
    @writeToBuffer(note, beat, buffer.getChannelData(0))

    source = Mixer.context.createBufferSource()
    source.buffer = buffer
    source.connect(@chainStart)

    source.start(beat.getSubdivisionTime(note.subdivision))

  # Write custom data to the buffer
  writeToBuffer: (note, beat, buffer) ->
    # do something

  # Calculate the length the buffer should be
  getBufferLength: (note, beat) -> 
    return note.duration * beat.samples

module.exports = BufferInstrument