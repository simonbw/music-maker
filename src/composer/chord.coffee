Util = require "../util.coffee"

chords = {}

class Chord
  @get: (symbol) ->
    if symbol not in chords
      throw new Error("Bad Chord: #{symbol}")
    return chords[symbol]

  constructor: (@root, @intervals) ->
    @pitches = (i + @root for i in @intervals)

  inversion: (degree = 1) ->
    return (@pitches[(i + degree) % @pitches.length] for i in [0...@pitches.length])

  contains: (pitch) ->
    pitch = Util.mod(pitch, 12)

  toString: ->
    return "<Chord: #{@pitches}>"

major = [0, 4, 7]
major7 = [0, 4, 7, 10]
majorM7 = [0, 4, 7, 11]
minor = [0, 3, 7]
minor7 = [0, 3, 7, 10]
minorM7 = [0, 3, 7, 11]

numerals = ['i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii']
for i in [0...numerals.length]
  numeral = numerals[i]

  chords[numeral] = new Chord(i, minor)
  chords[numeral + '7'] = new Chord(i, minor7)
  chords[numeral + 'M7'] = new Chord(i, minorM7)
  chords[numeral.toUpperCase()] = new Chord(i, major)
  chords[numeral.toUpperCase() + '7'] = new Chord(i, major7)
  chords[numeral.toUpperCase() + 'M7'] = new Chord(i, majorM7)

module.exports = Chord