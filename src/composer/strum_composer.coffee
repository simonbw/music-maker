Chord = require "./chord.coffee"
Composer = require "./composer.coffee"
DrumComposer = require './drum_composer.coffee'
Mixer = require '../mixer.coffee'
Note = require '../note.coffee'
Random = require "../random.coffee"
Scale = require "./scale.coffee"

class StrumComposer extends Composer
  STRINGS = [-17, -12, -7, -2, 2, 5]
  G   = [3, 2, 0, 0, 0, 3]
  C   = [null, 3, 2, 0, 1, 0]
  C7  = [null, 3, 2, 7, 1, 0]
  D   = [null, null, 0, 2, 3, 2]
  D7  = [null, null, 0, 2, 1, 2]
  Em  = [0, 2, 2, 0, 0, 0]
  Em7 = [0, 2, 2, 0, 7, 0]
  Am  = [null, 0, 2, 2, 1, 0]

  constructor: () ->
    super()
    @chord = null
    @rhythmPattern = [[1], [1 / 2, 1 / 2], [1], [1 / 2, 1 / 2]]
    
  generateTempo: () ->
    return 120

  generateGuitar: () ->
    notes = []

    down = true
    rhythm = @rhythmPattern[@beat]

    subdivision = 0
    for length in rhythm
      attack = 0.3 + down * 0.6
      @generateStrum(@chord, down, length, subdivision, attack, notes)
      subdivision += length
      down = !down

    return notes

  generateStrum: (frets = null, down = true, length = 1, subdivision = 0, attack = 0.3, notes = null) ->
    console.log "strum"
    frets = @chord
    notes ?= []
    separation = 0.038

    pitches = []
    for fret, string in frets
      unless fret is null
        pitches.push(fret + STRINGS[string])
    # up strum
    if not down
      pitches.reverse()

    for pitch, i in pitches
      note = new Note(pitch)
      note.setSubdivision(i * separation + subdivision)
      note.setAttack(attack)
      notes.push(note)
    return notes

  nextBar: () ->
    super()
    @chord = switch @chord
      when G   then Random.choose([G, C, C7, D])
      when C   then Random.choose([G, C, C7, D])
      when C7  then Random.choose([G, D])
      when D   then Random.choose([D7, G, Em])
      when D7  then Random.choose([G, Em])
      when Em  then Random.choose([C, C7, G])
      when Em7 then Random.choose([C, C7, G])
      else G
    console.log @chord
module.exports = StrumComposer
