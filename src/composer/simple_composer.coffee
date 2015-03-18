Composer = require "./composer.coffee"
DrumComposer = require './drum_composer.coffee'
Mixer = require '../mixer.coffee'
Note = require '../note.coffee'
Random = require "../random.coffee"
Scale = require "./scales.coffee"

# Creates simple music
class SimpleComposer extends Composer
  OCTAVE = 12

  constructor: ->
    super()
    @key = 0
    @beatsPerBar = 16
    @drumComposer = new DrumComposer(this)

  generateTempo: ->
    return 400

  generateHigh: ->
    notes = []
    notes.push(new Note(Random.choose(Scale.PENTATONIC_MINOR) + OCTAVE + @key))
    return notes

  generateLead: ->
    notes = []
    if @beat % 2 == 0 and Math.random() < 0.4
      notes.push(new Note(Random.choose(Scale.PENTATONIC_MINOR) - OCTAVE + @key).setDuration(2))
    return notes

  generateBass: ->
    notes = []
    if @beat % 8 == 0 and Math.random() < 0.9
      notes.push(new Note(Random.choose(Scale.PENTATONIC_MINOR) - 3 * OCTAVE + @key).setDuration(8))
    return notes
  
  generateDrums: ->
    notes = @drumComposer.groove[@beat]
    if @bar == 3
      if @phrase % 4 == 3
        notes = @drumComposer.bigFill[@beat]
      else if @beat >= @beatsPerBar / 2
        notes = @drumComposer.smallFill[@beat - @beatsPerBar / 2]
    return notes

  nextBar: ->
    super()

  nextPhrase: ->
    super()
    @drumComposer.nextGroove()
    @drumComposer.nextSmallFill()

  nextSection: ->
    super()
    @drumComposer.nextBigFill()
  
module.exports = SimpleComposer
