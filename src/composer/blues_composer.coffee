Composer = require "./composer.coffee"
Drumset = require "../instruments/drumset.coffee"
Mixer = require '../mixer.coffee'
Note = require '../note.coffee'
Random = require "../random.coffee"
Scale = require "./scales.coffee"
BluesSoloComposer = require "./blues_solo_composer.coffee"

# Creates simple music
class BluesComposer extends Composer
  OCTAVE = 12
  SWING = 2 / 3

  I = [0, 4, 7]
  IV = [5, 9, 12]
  V = [7, 11, 14]

  constructor: ->
    super()
    @beatsPerBar = 4
    @barsPerPhrase = 4
    @phrasesPerSection = 3

    @key = 0
    @chords = [I, I, I, I, IV, IV, I, I, V, IV, I, V]
    @chord = I

    @soloComposer = new BluesSoloComposer(this)

  generateTempo: ->
    return 100

  generateHigh: ->
    notes = []
    return notes

  generateLead: ->
    return @soloComposer.getBeat()

  generateBass: ->
    notes = []
    notes.push(
      new Note(@chord[0] - 2 * OCTAVE)
        .setAttack(0.8)
        .setDuration(1 / 2))
    notes.push(
      new Note(@chord[0] - 2 * OCTAVE)
        .setAttack(0.6)
        .setSubdivision(SWING)
        .setDuration(1 / 3))
    return notes
  
  generateDrums: ->
    notes = []
    notes.push(
      new Note(Drumset.HIHAT)
        .setAttack(0.9))
    notes.push(
      new Note(Drumset.HIHAT)
        .setAttack(0.6)
        .setSubdivision(SWING))
    if @beat % 2 == 0
      notes.push(new Note(Drumset.BASS))
    if @beat % 2 == 1
      notes.push(new Note(Drumset.SNARE))
    return notes

  nextBar: ->
    @chord = @chords[@bar + @phrase * @barsPerPhrase]
    super()

  nextPhrase: ->
    super()

  nextSection: ->
    super()
  
module.exports = BluesComposer
