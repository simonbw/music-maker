
# Base class for all instruments
class window.Instrument
  # Create a new instrument
  constructor: (gain = 1.0) ->
    @output = Mixer.context.createGain()
    @output.gain.value = gain
    @chainStart = @output # the first node in the effects chain

  # Play a note
  play: (note) ->
    # do something


# Base class for instruments that fill a buffer on their own
class window.BufferInstrument extends Instrument
  # Play a note
  play: (note) ->
    buffer = Mixer.context.createBuffer(1, @getBufferLength(note), Mixer.context.sampleRate)
    @writeToBuffer(note, buffer.getChannelData(0))

    source = Mixer.context.createBufferSource()
    source.buffer = buffer
    source.connect(@chainStart)
    source.start()

  # Write custom data to the buffer
  writeToBuffer: (note, buffer) ->
    # do something

  # Calculate the length the buffer should be
  getBufferLength: (note) -> 
    return note.duration * Mixer.getSamplesPerBeat()


class window.OscillatorInstrument extends Instrument
  constructor: (gain, @oscillatorType='sine', @attackTime=0.01) ->
    super(gain)

  play: (note) ->
    startTime = Mixer.context.currentTime
    endTime = startTime + note.duration * 60 / Mixer.tempo
    
    oscillator = @makeOscillator(note)

    gainNode = Mixer.context.createGain()
    gainNode.connect(@chainStart)
    oscillator.connect(gainNode)
    
    @doGain(note, gainNode, startTime, endTime)

    oscillator.start(startTime)
    oscillator.stop(endTime)

  makeOscillator: (note) ->
    oscillator = Mixer.context.createOscillator()
    oscillator.frequency.value = note.frequency
    oscillator.type = @oscillatorType
    return oscillator

  doGain: (note, gainNode, startTime, endTime) ->
    gainNode.gain.linearRampToValueAtTime(0, startTime)
    gainNode.gain.linearRampToValueAtTime(note.attack, startTime + @getAttackTime(note))
    gainNode.gain.linearRampToValueAtTime(0, endTime)

  getAttackTime: (note) ->
    return @attackTime
