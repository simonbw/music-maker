Chord = require "./chord.coffee"
Composer = require "./composer.coffee"
DrumComposer = require './drum_composer.coffee'
Mixer = require '../mixer.coffee'
Note = require '../note.coffee'
Random = require "../random.coffee"
Scale = require "./scale.coffee"

class StrumComposer extends Composer
  MUTE = new Object()
  STRINGS = [-17, -12, -7, -2, 2, 7]
  G   = [3, 2, 0, 0, 0, 3]
  C   = [null, 3, 2, 0, 1, 0]
  C7  = [null, 3, 2, 3, 1, 0]
  D   = [null, null, 0, 2, 3, 2]
  D7  = [null, null, 0, 2, 1, 2]
  Em  = [0, 2, 2, 0, 0, 0]
  Em7 = [0, 2, 2, 0, 3, 0]
  Am  = [null, 0, 2, 2, 1, 0]

  E5 = [0, 2, 2, MUTE, MUTE, MUTE]
  G5 = [3, 5, 5, MUTE, MUTE, MUTE]
  A5 = [5, 7, 7, MUTE, MUTE, MUTE]
  B5 = [MUTE, 2, 4, 4, MUTE, MUTE]

  constructor: () ->
    super()
    @chord = B5
    @rhythmPattern = [[1], [1 / 2, 1 / 2], [1], [1 / 2, 1 / 2]]

  generateTempo: () ->
    return 180

  generateDrums: () ->
    notes = []
    if @beat % 2 == 0
      notes.push(new Note(0))
    return notes

  generateGuitar: () ->
    notes = []

    down = true
    rhythm = @rhythmPattern[@beat]

    subdivision = 0
    for length in rhythm
      attack = 0.3 + down * 0.6
      palm = @beat % 2 == 1
      palm *= 0.8
      @generateStrum(@chord, down, length, subdivision, attack, notes, palm)
      subdivision += length
      down = !down

    return notes

  generateStrum: (frets = null, down = true, length = 1, subdivision = 0, attack = 0.3, notes = null, palm = null) ->
    frets = @chord
    notes ?= []
    separation = 0.01 * @generateTempo() / 60

    pitches = []
    for fret, string in frets
      if fret is MUTE
        continue
      if fret is null
        pitches.push(null)
      else
        pitches.push(fret + STRINGS[string])
    # up strum
    if not down
      pitches.reverse()

    for pitch, i in pitches
      if not (pitch is null)
        note = new Note(pitch)
        note.setSubdivision(i * separation + subdivision)
        note.setAttack(attack)
        note.addModifier('string', i)
        if palm? then note.addModifier('palm', palm)
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
      when Em  then Random.choose([Em, Em7, C, C7, G])
      when Em7 then Random.choose([Em7, C, C7, G])
        # Power chord stuff
      when E5 then G5
      when G5 then A5
      when A5 then B5
      when B5 then E5
      else G

module.exports = StrumComposer
