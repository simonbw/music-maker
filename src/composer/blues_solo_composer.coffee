Note = require '../note.coffee'
Random = require "../random.coffee"
Scale = require "./scales.coffee"
Util = require "../util.coffee"

class BluesSoloComposer
  UP = true
  DOWN = false

  constructor: (@composer) ->
    @scale = Scale.BLUES_MAJOR
    @lastPitchIndex = Random.int(@scale.length)
    @direction = Random.bit()
    @lastDuration = 0

  getBeat: () ->
    notes = []
    currentSubdivision = 0

    while currentSubdivision < 6
      remainingSubdivisions = 6 - currentSubdivision
      durationChances = [
        [1, 1]
        [2, 2.5]
        [3, 1]
        [4, 4]
        [5, 0.1]
        [6, 6]
      ]

      pitch = @nextPitch()

      consonant = Util.mod(pitch, 12) in @composer.chord

      if consonant
        durationChances[5][1] *= 8
        durationChances[3][1] *= 6

      if currentSubdivision == 0
        durationChances[3][1] += 10

      if currentSubdivision == 2
        durationChances[3][1] *= 0.3

      if currentSubdivision % 2 == 0
        durationChances[1][1] += 5

      if currentSubdivision % 2 == 1
        durationChances[0][1] += 10

      if currentSubdivision == 3
        durationChances[2][1] += 30

      if @lastDuration == 3
        durationChances[2][1] *= 20

      if @lastDuration == 6
        durationChances[5][1] *= 3

      if @lastDuration == 1
        durationChances[0][1] += 2
        durationChances[0][1] *= 20
        durationChances[0][1] += 20

      # Make sure we can't play notes that will go outside the beat
      for i in [0...durationChances.length]
        durationChances[i][1] *= (durationChances[i][0] <= remainingSubdivisions)

      @lastDuration = duration = Random.weightedChoose(durationChances)

      restChance = 0.01 * duration
      if currentSubdivision == 1
        restChance += 0.1

      if not Random.bit(restChance)
        attack = 0.5
        if consonant
          attack += 0.1
        if currentSubdivision == 0
          attack += 0.2
        if currentSubdivision == 4
          attack += 0.1
        if currentSubdivision % 2 == 0
          attack += 0.1

        note = new Note(pitch)
          .setAttack(attack)
          .setDuration(duration / 6)
          .setSubdivision(currentSubdivision / 6)
        notes.push(note)

      currentSubdivision += duration

    return notes

  nextPitch: () ->
    upChance = 0.1 + @direction * 0.8
    upChance -= @lastPitchIndex / 30
    downChance = 1 - upChance
    @direction = Random.bit(upChance)

    variation = 0.3
    chance = @direction ? 1 - variation : 0 + variation
    chances = [
      [5, 0.2 * upChance] #octave
      [5, 0.2 * upChance]
      [4, 0.2 * upChance]
      [3, 1 * upChance]
      [2, 2 * upChance]
      [1, 10 * upChance]
      [0, 3]
      [-1, 10 * downChance]
      [-2, 2 * downChance]
      [-3, 1 * downChance]
      [-4, 0.2 * downChance]
      [-5, 0.0 * downChance]
      [-5, 0.2 * downChance] #octave
    ]
    @lastPitchIndex += Random.weightedChoose(chances)
    octave = Math.floor(@lastPitchIndex / @scale.length)
    return @scale[Util.mod(@lastPitchIndex, @scale.length)] + octave * 12

module.exports = BluesSoloComposer
