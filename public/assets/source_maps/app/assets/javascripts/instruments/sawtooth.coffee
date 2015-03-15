
class window.Sawtooth extends Instrument
  writeToBuffer: (note, buffer) ->
    for sample, i in buffer
      volume = (buffer.length - i) / buffer.length * note.attack
      buffer[i] = ((note.frequency * i / Mixer.context.sampleRate) % 2 - 1) * volume;
