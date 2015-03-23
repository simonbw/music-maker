BluesSoloComposer = require "./blues_solo_composer.coffee"
Chord = require "./chord.coffee"
Composer = require "./composer.coffee"
Drumset = require "../instruments/drumset.coffee"
Mixer = require '../mixer.coffee'
Note = require '../note.coffee'
Random = require "../random.coffee"
Scale = require "./scale.coffee"

# Creates simple music
class BluesComposer extends Composer
  OCTAVE = 12
  SWING = 2 / 3

  # Chords
  i = Chord.get(0, 'min')
  iv = Chord.get(5, 'min')
  iv7 = Chord.get(5, 'min7')
  v = Chord.get(7, 'min')
  v7 = Chord.get(7, 'min7')
  V = Chord.get(7, 'maj')

  constructor: ->
    super()
    @beatsPerBar = 4
    @barsPerPhrase = 4
    @phrasesPerSection = 3

    @key = 0
    @chords = [i, i, i, i, iv, iv7, i, i, v7, iv, i, V]
    @chord = i

    @soloComposer = new BluesSoloComposer(this)

  generateTempo: ->
    return 80

  generateHigh: ->
    notes = []
    inversion = switch @chord
      when i   then 0
      when iv  then 2
      when iv7 then 2
      when v   then 2
      when v7   then 2
      when V   then 2
    for pitch in @chord.inversion(inversion)
      notes.push(
        new Note(pitch % 12 + OCTAVE)
          .setDuration(1 / 6))

    for pitch in @chord.inversion(inversion)
      notes.push(
        new Note(pitch % 12 + OCTAVE)
          .setDuration(1 / 6)
          .setSubdivision(2 / 3))
    return notes

  generateLead: ->
    return @soloComposer.getBeat()

  generateBass: ->
    notes = []
    notes.push(
      new Note(@chord.root - 2 * OCTAVE)
        .setAttack(0.8)
        .setDuration(1 / 2))
    notes.push(
      new Note(@chord.root - 2 * OCTAVE)
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
