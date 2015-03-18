# Base class for generic composer
class Composer
  constructor: ->
    @section = 0
    @phrase = 0
    @bar = 0
    @beat = 0

    @phrasesPerSection = 4
    @barsPerPhrase = 4
    @beatsPerBar = 4

  nextBeat: ->
    if @beat == 0
      @nextBar()
    
    notes = {
      'tempo': @generateTempo()
      'high': @generateHigh()
      'lead': @generateLead()
      'bass': @generateBass()
      'drums': @generateDrums()
    }

    @advanceCount()

    return notes

  generateTempo: ->
    return 120

  generateHigh: ->
    return []

  generateLead: ->
    return []
  
  generateBass: ->
    return []

  generateDrums: ->
    return []

  nextBar: ->
    if @bar == 0
      @nextPhrase()

  nextPhrase: ->
    if @phrase == 0
      @nextSection()

  nextSection: ->
    console.log "new section"
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
