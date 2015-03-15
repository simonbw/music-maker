

class window.HiHat extends BufferInstrument
  constructor: (gain) ->
    super(gain)

    @filter = Mixer.context.createBiquadFilter()
    @filter.type = 'highpass'
    @filter.frequency.value = 12000
    @filter.Q.value = 20.0
    @filter.connect(@output)

    @chainStart = @filter

  writeToBuffer: (note, buffer) ->
    for sample, i in buffer
      decay = Math.pow((i / buffer.length) * note.attack * note.attack, 0.8)
      d = (Math.random() * 2 - 1) * (1 - decay) * note.attack
      buffer[i] = d

  getBufferLength: (note) ->
    return Math.ceil(0.22 * Mixer.context.sampleRate)