SimpleComposer = require "./composer/simple_composer.coffee"
Conductor = require "./conductor.coffee"
Drumset = require "./instruments/drumset.coffee"
Mixer = require "./mixer.coffee"
SawtoothSynth = require "./instruments/sawtooth_synth.coffee"
SquareSynth = require "./instruments/square_synth.coffee"
TriangleSynth = require "./instruments/triangle_synth.coffee"
Visualizer = require "./visualizer.coffee"

window.onload = -> 
  instruments = {
    'high': new TriangleSynth(0.1)
    'lead': new SquareSynth(0.1)
    'bass': new SawtoothSynth(0.08)
    'drums': new Drumset(0.5)
  }

  for name, instrument of instruments
    instrument.output.connect(Mixer.output)

  composer = composer = new SimpleComposer()
  window.conductor = new Conductor(composer, instruments)

  masterVisualizer = new Visualizer(256)
  Mixer.output.connect(masterVisualizer.input)
  document.querySelector('#visualizers').appendChild(masterVisualizer.element)

  document.querySelector('#start_button').onclick = conductor.start
  document.querySelector('#stop_button').onclick = conductor.stop