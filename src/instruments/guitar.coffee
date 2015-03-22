BufferInstrument = require "./buffer_instrument.coffee"
Mixer = require "../mixer.coffee"
Random = require "../random.coffee"

class Guitar extends BufferInstrument
  BUFFER_LENGTH = 3.0
  RELEASE_LENGTH = 0.05
  STRINGS = [-17, -12, -7, -2, 2, 5]

  @getN: (f) ->
    return 2 * Mixer.context.sampleRate / f

  constructor: (gain) ->
    super(gain)

    @stringSources = []
    for i in [0...6]
      @stringSources.push(null)

    # TODO: Move this to an acoustic guitar
    @filter = Mixer.context.createBiquadFilter()
    @filter.type = 'lowpass'
    @filter.frequency.value = 12000
    @filter.gain.value = 0
    @filter.Q.value = 0.2
    @filter.connect(@output)

    @chainStart = Mixer.context.createGain()
    @dry = Mixer.context.createGain()
    @dry.gain.value = 0.2
    @wet = Mixer.context.createGain()
    @wet.gain.value = 0.8
    @chainStart.connect(@dry)
    @chainStart.connect(@wet)
    @dry.connect(@output)
    @wet.connect(@filter)

  play: (note, beat) ->
    startTime = beat.getSubdivisionTime(note.subdivision)
    
    string = note.getModifier('string')
    # best guess
    if string is undefined
      string = 0
      for stringPitch, i in STRINGS
        if note.pitch >= stringPitch
          string = i
        else break

    if @stringSources[string]
      @stringSources[string].stop(startTime)

    buffer = Mixer.getBuffer(@getNoteLength(note, beat))
    @writeToBuffer(note, beat, buffer.getChannelData(0))

    source = Mixer.context.createBufferSource()
    source.buffer = buffer
    source.connect(@getNoteChain(note, beat))

    @stringSources[string] = source
    source.start(beat.getSubdivisionTime(note.subdivision))

  writeToBuffer: (note, beat, buffer) ->
    N = Math.round(Guitar.getN(note.frequency))
    palm = if note.hasModifier('palm') then note.getModifier('palm') else 0

    bends = []
    for pitchBend in note.pitchBends
      bend = {
        startN: Guitar.getN(pitchBend.fromFrequency)
        endN: Guitar.getN(pitchBend.toFrequency)
        startSample: Math.floor(beat.samples * pitchBend.start)
        endSample: Math.floor(beat.samples * pitchBend.end)
      }
      bend.length = bend.endSample - bend.startSample
      bends.push(bend)

    # fill buffer
    value = 0
    smoothing = 1 - note.attack * 0.3 * (1 - palm * 0.7)
    smoothing2 = 1 - smoothing
    volume = 0.7 + 0.3 * Math.pow(note.attack, 0.7)
    for i in [0...N]
      if bends.length
        bend = bends[0]
        if i >= bend.startSample
          if i > bend.endSample
            bends.shift()
          else
            percent = (i - bend.startSample) / bend.length
            N = Math.round((1 - percent) * bend.startN + percent * bend.endN)
      value = smoothing * value + smoothing2 * Random.uniform(-1, 1) * volume
      buffer[i] = value

    # Do the rest of it
    releaseSamples = Math.floor(Mixer.context.sampleRate * RELEASE_LENGTH)
    smoothing = 0.65 - note.attack * 0.2 * (1 - 0.5 * palm) + palm * 0.3
    smoothing2 = 1 - smoothing
    weights = [1, 1]
    total = 0
    total += w for w in weights
    for i in [N...buffer.length]
      if bends.length
        bend = bends[0]
        if i >= bend.startSample
          if i > bend.endSample
            bends.shift()
          else
            percent = (i - bend.startSample) / bend.length
            N = Math.round((1 - percent) * bend.startN + percent * bend.endN)

      avg = 0
      for weight, j in weights
        avg += (weight / total) * buffer[i - N + j]
      decay = 0.004 + palm * 0.08

      if i > buffer.length - releaseSamples
        decay = 0.3 + 0.4 * (buffer.length - i) / releaseSamples
      
      # avg = (buffer[i - N] + buffer[i - N + 1]) / 2
      value = smoothing * value + smoothing2 * avg * (1 - decay)
      buffer[i] = value

  getNoteLength: (note, beat) ->
    return super(note, beat) + RELEASE_LENGTH

  getNoteChain: (note, beat) ->
    palm = note.hasModifier('palm')

    filter1 = Mixer.context.createBiquadFilter()
    filter1.type = 'lowpass'
    filter1.Q.value = 0.01
    filter1.frequency.value = note.frequency * 10 + 4000

    filter2 = Mixer.context.createGain()
    
    filter1.connect(filter2)

    start = filter1
    end = filter2
    end.connect(@chainStart)
    return end

module.exports = Guitar
