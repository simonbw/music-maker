
class window.Drumset extends Instrument
  # map from pitch to drum
  @BASS = BASS = 0
  @SNARE = SNARE = 1
  @HIHAT = HIHAT = 2

  constructor: (gain) ->
    super(gain)
    
    @hihat = new HiHat(0.1)
    @snare = new SnareDrum(1.0)
    @bass = new BassDrum(1.0)

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
