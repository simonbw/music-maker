
class window.Square extends Instrument
  writeToBuffer: (note, buffer) ->
    for sample, i in buffer
      volume = 1 #(buffer.length - i) / buffer.length * note.attack
      buffer[i] = ((Math.sin(note.frequency * i / Mixer.context.sampleRate * Math.PI)) > 0 ? 1 : -1) * volume;
      
