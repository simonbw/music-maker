Mixer = require "../mixer.coffee"
Instrument = require "./instrument.coffee"
HiHat = require "./drums/hihat.coffee"
SnareDrum = require "./drums/snaredrum.coffee"
BassDrum = require "./drums/bassdrum.coffee"

class Drumset extends Instrument
  # map from pitch to drum
  @BASS = BASS = 0
  @SNARE = SNARE = 1
  @HIHAT = HIHAT = 2

  constructor: (gain) ->
    super(gain)
    
    @hihat = new HiHat(0.05)
    @snare = new SnareDrum(1.0)
    @bass = new BassDrum(0.5)

    @hihat.output.connect(@chainStart)
    @snare.output.connect(@chainStart)
    @bass.output.connect(@chainStart)

  play: (note, beat) ->
    switch note.pitch
      when BASS
        @bass.play(note, beat)
      when SNARE
        @snare.play(note, beat)
      when HIHAT
        @hihat.play(note, beat)

module.exports = Drumset