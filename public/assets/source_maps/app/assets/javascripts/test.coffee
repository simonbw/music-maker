$(document).ready -> 
  instruments = {
    'high': new TriangleSynth(0.1)
    'lead': new SquareSynth(0.1)
    'bass': new SawtoothSynth(0.08)
    'drums': new Drumset(0.5)
  }

  for name, instrument of instruments
    instrument.output.connect(Mixer.output)

  composer = composer = new Composer()
  window.conductor = new Conductor(composer, instruments)

  masterVisualizer = new Visualizer(16)
  Mixer.output.connect(masterVisualizer.input)
  $('.visualizers').append(masterVisualizer.element)

  startOnFocus = false
  $('#start_button').click(conductor.start)
  $('#stop_button').click(conductor.stop)

  # $(window).blur ->
  #   startOnFocus = conductor.playing
  #   conductor.stop()

  # $(window).focus ->
  #   if startOnFocus
  #     conductor.start()
