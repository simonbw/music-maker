Util = require "../util.coffee"

chords = {
  maj: [0, 4, 7]
  maj7: [0, 4, 7, 10]
  majM7: [0, 4, 7, 11]
  min: [0, 3, 7]
  min7: [0, 3, 7, 10]
  minM7: [0, 3, 7, 11]
}

class Chord
  OCTAVE = 12

  @get: (root, type='maj') ->
    if not type of chords
      throw new Error("Bad Chord: #{type}")
    return new Chord(root, chords[type])

  constructor: (@root, @intervals) ->
    @pitches = (i + @root for i in @intervals)

  inversion: (degree = 1) ->
    result = []
    for i in [0...@pitches.length]
      octave = Math.floor(i / @pitches.length) * OCTAVE
      result.push(@pitches[(i + degree) % @pitches.length] + octave)
    return result

  contains: (pitch) ->
    pitch = Util.mod(pitch, 12)
    return pitch in @pitches

  toString: ->
    return "<Chord: #{@pitches}>"

window.Chord = Chord
console.log "CHORDS"
module.exports = Chord