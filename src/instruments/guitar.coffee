BufferInstrument = require "./buffer_instrument.coffee"
Mixer = require "../mixer.coffee"
Random = require "../random.coffee"

class Guitar extends BufferInstrument
  constructor: (gain) ->
    super(gain)
    # @filter = Mixer.context.createBiquadFilter()
    # @filter.connect(@chainStart)
    # @filter.type = 'lowpass'
    # @filter.frequency.value = 12000
    # @filter.Q.value = 0.15
    # # @chainStart = @filter
  
  @getN: (f) ->
    return 2 * Mixer.context.sampleRate / f

  writeToBuffer: (note, beat, buffer) ->
    N = Math.round(Guitar.getN(note.frequency))

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
    smoothing = 1 - note.attack
    smoothing2 = 1 - smoothing
    for i in [0...N]
      if bends.length
        bend = bends[0]
        if i >= bend.startSample
          if i > bend.endSample
            bends.shift()
          else
            percent = (i - bend.startSample) / bend.length
            N = Math.round((1 - percent) * bend.startN + percent * bend.endN)
      value = smoothing * value + smoothing2 * Random.uniform(-1, 1)
      buffer[i] = value

    # Do the rest of it
    smoothing = 0.005
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
      decay = 0.001
      # avg = (buffer[i - N] + buffer[i - N + 1]) / 2
      value = smoothing * value + smoothing2 * avg * (1 - decay)
      buffer[i] = value

  getNoteChain: (note, beat) ->
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
