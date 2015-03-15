$(document).ready -> 
  window.musicmaker = {}

  console.log("Started")

  musicmaker.instruments = instruments = {
    'high': new TriangleSynth(0.1)
    'lead': new SquareSynth(0.1)
    'bass': new SawtoothSynth(0.08)
    'drums': new Drumset(0.3)
  }

  for name, instrument of instruments
    instrument.output.connect(Mixer.output)

  musicmaker.composer = composer = new Composer()
  Mixer.setTempo(100)

  nextBeat = () ->
    beat = composer.nextBeat()
    for instrument, notes of beat
      if notes is undefined
        throw "Error: undefined notes for instrument #{instrument}"
      for note in notes
        instruments[instrument].play(note)

    window.timeoutId = window.setTimeout(nextBeat, Mixer.getMillisecondsPerBeat())

  masterVisualizer = new Visualizer(16)
  Mixer.output.connect(masterVisualizer.input)

  $('.visualizers').append(masterVisualizer.element)

  window.stopPlaying = () ->
    clearTimeout(timeoutId)

  $('#stop_button').click(stopPlaying)
  
  nextBeat()
