Mixer = require "../mixer.coffee"
Util = require "../util.coffee"
Effect = require "./effect.coffee"
Samples = require "../samples.coffee"
SimpleReverb = require "./simple_reverb.coffee"
SimpleEQ = require "./simple_eq.coffee"
Cabinet = require "./cabinet.coffee"

class GuitarAmp extends Effect
  constructor: () ->
    super()

    @gain1 = Mixer.context.createGain() # dirty
    @gain2 = Mixer.context.createGain() # sustain
    @gain3 = Mixer.context.createGain() # volume
    @drive = Mixer.context.createWaveShaper()
    @dynamics = Mixer.context.createDynamicsCompressor()
    @lowCut = Mixer.context.createBiquadFilter()
    @midCut = Mixer.context.createBiquadFilter()
    @eq = new SimpleEQ()
    @cabinet = new Cabinet()
    
    @setDrive(1)
    @setSustain(5)

    @drive.curve = @makeDistortionCurve(10)

    @eq.setLevels(-8, 0, 5)

    @lowCut.type = 'highpass'
    @lowCut.frequency.value = 110
    @lowCut.Q.value = 1

    @midCut.type = 'peaking'
    @midCut.frequency.value = 240
    @midCut.Q.value = 0.8
    @midCut.gain.value = -3

    @dynamics.attack.value = 0.001
    @dynamics.release.value = 0.001
    @dynamics.knee.value = 25
    @dynamics.ratio.value = 11

    @cabinet.setWet(1)

    Util.connectAll(
      @wet,
      @gain1,
      @drive,
      @gain2,
      @dynamics,
      @eq,
      @gain3,
      @cabinet,
      @midCut,
      @lowCut,
      @output)

  setDrive: (value) =>
    @gain1.gain.value = Math.pow(2, value - 2)

  setSustain: (value) =>
    @gain2.gain.value = Math.pow(2, value - 2) # 0.25 to 256
    @gain3.gain.value = 2 / (2 * value + 0.5)  # 0.19 to 4

  makeDistortionCurve: (amount) ->
    samples = 22050
    curve = new Float32Array(samples)
    deg = Math.PI / 180
    for i in [0...samples]
      x = (i / curve.length) * 2 - 1
      output = (3 + amount) * x * 20 * deg / (Math.PI + amount * Math.abs(x))
      curve[i] = output
    return curve

module.exports = GuitarAmp
