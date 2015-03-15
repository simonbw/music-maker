
# class window.Sine extends Instrument
#   writeToBuffer: (note, buffer) ->
#     for sample, i in buffer
#       volume = (buffer.length - i) / buffer.length * note.attack
#       buffer[i] = Math.sin(note.frequency * i / Mixer.context.sampleRate * Math.PI) * volume;


class window.SineSynth extends Instrument
  ATTACK_TIME = 0.005

  play: (note) ->
    startTime = Mixer.context.currentTime
    endTime = startTime + note.duration * 60 / Mixer.tempo
    
    oscillator = Mixer.context.createOscillator()
    oscillator.frequency.value = note.frequency
    oscillator.type = 'sine'

    gainNode = Mixer.context.createGain()
    oscillator.connect(gainNode)
    gainNode.connect(@chainStart)

    gainNode.gain.linearRampToValueAtTime(0, startTime)
    gainNode.gain.linearRampToValueAtTime(note.attack, startTime + ATTACK_TIME)
    gainNode.gain.linearRampToValueAtTime(0, endTime)

    oscillator.start(startTime)
    oscillator.stop(endTime)
