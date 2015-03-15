
class window.Instrument
  constructor: (gain = 1.0) ->
    @output = Mixer.context.createGain()
    @output.gain.value = gain

  play: (note) ->
    buffer = Mixer.context.createBuffer(1, @getBufferLength(note), Mixer.context.sampleRate)
    @writeToBuffer(note, buffer.getChannelData(0))

    source = Mixer.context.createBufferSource()
    source.buffer = buffer
    source.connect(@output)
    source.start()

  writeToBuffer: (note, buffer) ->
    # do something

  getBufferLength: (note) -> 
    return note.duration * Mixer.getSamplesPerBeat()
