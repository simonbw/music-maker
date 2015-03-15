
# class window.Sine extends Instrument
#   writeToBuffer: (note, buffer) ->
#     for sample, i in buffer
#       volume = (buffer.length - i) / buffer.length * note.attack
#       buffer[i] = Math.sin(note.frequency * i / Mixer.context.sampleRate * Math.PI) * volume;


class windowSine extends Instrument
  play: (note) ->
    oscillator = Mixer.context.createOscillator()
    oscillator.frequency.value = note.value
    oscillator.type = 'sine'

    oscillator.connect(gain)
    gain = Mixer.context.createGain()
    gain.value(oscillator.attack)
    gain.connect(@chainStart)

    oscillator.start()
