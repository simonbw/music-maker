Mixer = require "../mixer.coffee"
Instrument = require "./instrument.coffee"

# Base class for instruments that fill a buffer on their own
class BufferInstrument extends Instrument
  # Play a note
  play: (note, beat) ->
    buffer = Mixer.getBuffer(@getNoteLength(note, beat))
    @writeToBuffer(note, beat, buffer.getChannelData(0))

    source = Mixer.context.createBufferSource()
    source.buffer = buffer
    source.connect(@getNoteChain(note, beat))

    source.start(beat.getSubdivisionTime(note.subdivision))

  getNoteChain: (note, beat) ->
    return @chainStart

  # Write custom data to the buffer
  writeToBuffer: (note, beat, buffer) ->
    # do something

  # Calculate the length the buffer should be
  getNoteLength: (note, beat) -> 
    return note.duration * beat.length

module.exports = BufferInstrument