Conductor = require "./conductor.coffee"
Drumset = require "./instruments/drumset.coffee"
Mixer = require "./mixer.coffee"
SawtoothSynth = require "./instruments/sawtooth_synth.coffee"
SineSynth = require "./instruments/sine_synth.coffee"
SimpleComposer = require "./composer/simple_composer.coffee"
BluesComposer = require "./composer/blues_composer.coffee"
SquareSynth = require "./instruments/square_synth.coffee"
TriangleSynth = require "./instruments/triangle_synth.coffee"
Visualizer = require "./visualizer.coffee"
SimpleReverb = require "./effects/simple_reverb.coffee"

window.onload = ->
  instruments = {
    'high': new TriangleSynth(0.05)
    'lead': new SquareSynth(0.03)
    'bass': new TriangleSynth(0.12)
    'drums': new Drumset(0.5)
  }

  reverb = new SimpleReverb(0.85, 0.24)
  reverb.output.gain.value = 3.2
  reverb.output.connect(Mixer.output)

  instruments.high.output.connect(reverb.input)
  instruments.lead.output.connect(Mixer.output)
  instruments.lead.output.connect(reverb.input)
  instruments.bass.output.connect(reverb.input)
  instruments.drums.output.connect(reverb.input)

  composer = composer = new BluesComposer()
  window.conductor = new Conductor(composer, instruments)

  masterVisualizer = new Visualizer(256)
  Mixer.output.connect(masterVisualizer.input)
  document.querySelector('#visualizers').appendChild(masterVisualizer.element)

  document.querySelector('#start_button').onclick = conductor.start
  document.querySelector('#stop_button').onclick = conductor.stop