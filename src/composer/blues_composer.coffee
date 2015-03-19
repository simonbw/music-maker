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

  # Chords
  I = [0, 4, 7]
  I7 = [0, 4, 7, 10]
  IV = [5, 9, 0]
  IV7 = [5, 9, 0, 3]
  V = [7, 11, 2]
  V7 = [7, 11, 2, 5]

  constructor: ->
    super()
    @beatsPerBar = 4
    @barsPerPhrase = 4
    @phrasesPerSection = 3

    @key = 0
    @chords = [I, IV, I, I, IV, IV7, I, I, V, IV7, I, V7]
    @chord = I

    @soloComposer = new BluesSoloComposer(this)

  generateTempo: ->
    return 100

  generateHigh: ->
    notes = []
    for pitch in @chord
      notes.push(
        new Note(pitch + OCTAVE)
          .setDuration(1 / 6))

    for pitch in @chord
      notes.push(
        new Note(pitch + OCTAVE)
          .setDuration(1 / 6)
          .setSubdivision(2 / 3))
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
