DrumComposer = require './drum_composer.coffee'
Mixer = require '../mixer.coffee'
Note = require '../note.coffee'
Random = require "../random.coffee"

class Composer
  OCTAVE = 12

  PENTATONIC_MAJOR = [0, 2, 4, 7, 9, 12]
  PENTATONIC_MINOR = [0, 3, 5, 7, 10, 12]

  constructor: ->
    @section = 0
    @phrase = 0
    @bar = 0
    @beat = 0

    @phrasesPerSection = 4
    @barsPerPhrase = 4
    @beatsPerBar = 16
    
    @key = 0
    @chord = 0
    @bassline = {}
    @drumComposer = new DrumComposer(this)

  nextBeat: ->
    if @beat == 0
      @nextBar()
    
    notes = {
      'high': @generateHigh(),
      'lead': @generateLead(),
      'bass': @generateBass(),
      'drums': @generateDrums()
    }

    @advanceCount()

    return notes

  generateHigh: ->
    notes = []
    notes.push(new Note(Random.choose(PENTATONIC_MINOR) + OCTAVE + @key))
    return notes

  generateLead: ->
    notes = []
    if @beat % 2 == 0 and Math.random() < 0.4
      notes.push(new Note(Random.choose(PENTATONIC_MINOR) - OCTAVE + @key).setDuration(2))
    return notes

  generateBass: ->
    notes = []
    if @beat % 8 == 0 and Math.random() < 0.9
      notes.push(new Note(Random.choose(PENTATONIC_MINOR) - 3 * OCTAVE + @key).setDuration(8))
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
    if @bar == 0
      @nextPhrase()
    # setup bar

  nextPhrase: ->
    if @phrase == 0
      @nextSection()
    console.log "next phrase"
    @drumComposer.nextGroove()
    @drumComposer.nextSmallFill()

  nextSection: ->
    console.log "next section"
    @drumComposer.nextBigFill()
    # setup section
  
  advanceCount: ->
    @beat += 1
    if @beat == @beatsPerBar
      @beat = 0
      @bar += 1
      if @bar == @barsPerPhrase
        @bar = 0
        @phrase += 1
        if @phrase == @phrasesPerSection
          @phrase = 0
          @section += 1

module.exports = Composer
