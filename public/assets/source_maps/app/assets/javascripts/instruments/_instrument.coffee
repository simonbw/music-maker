
# Base class for all instruments
class window.Instrument
  # Create a new instrument
  constructor: (gain = 1.0) ->
    @output = Mixer.context.createGain()
    @output.gain.value = gain
    @chainStart = @output # the first node in the effects chain

  # Play a note
  play: (note, beat) ->
    # do something


# Base class for instruments that fill a buffer on their own
class window.BufferInstrument extends Instrument
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


class window.OscillatorInstrument extends Instrument
  constructor: (gain, @oscillatorType='sine', @attackTime=0.01) ->
    super(gain)

  play: (note, beat) ->
    startTime = beat.getSubdivisionTime(note.subdivision)
    endTime = startTime + note.duration * beat.length
    
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
    gainNode.gain.setValueAtTime(0, startTime)
    gainNode.gain.linearRampToValueAtTime(note.attack, startTime + @getAttackTime(note))
    gainNode.gain.linearRampToValueAtTime(0, endTime)

  getAttackTime: (note) ->
    return @attackTime
