Note = require '../note.coffee'
Random = require "../random.coffee"
Scale = require "./scale.coffee"
Util = require "../util.coffee"

class BluesSoloComposer
  UP = true
  DOWN = false

  constructor: (@composer) ->
    @scale = Scale.BLUES_MINOR
    @lastPitchIndex = Random.int(@scale.length)
    @up = Random.bit() # whether we're heading up or down
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
    upChance = 0.1 + @up * 0.8
    upChance -= @lastPitchIndex / (3 * @scale.length)
    downChance = 1 - upChance
    @up = Random.bit(upChance)

    downChance = 1 - upChance
    # these are all tuned for minor blues
    chances = switch Util.mod(@lastPitchIndex, @scale.length)
      when 0 # 0
        [
          [5,  if @up then 5 else 0] # 12 octave
          [5,  if @up then 1 else 0] # 10
          [4,  if @up then 4 else 1] # 7
          [3,  if @up then 1 else 1] # 6 blue
          [2,  if @up then 1 else 1] # 5
          [1,  if @up then 8 else 1] # 3
          [0,  if @up then 1 else 1] # same
          [-1, if @up then 1 else 3] # 10 
          [-2, if @up then 0 else 1] # 7
          [-3, if @up then 0 else 4] # 6 blue
          [-4, if @up then 3 else 0] # 5 
          [-5, if @up then 0 else 0] # 3 
          [-5, if @up then 0 else 1] # 0 octave
        ]
      when 1 # 3
        [
          [1,  if @up then 3 else 0] # 5
          [0,  if @up then 1 else 1] # same
          [-1, if @up then 0 else 3] # 0 tonic
        ]
      when 2 # 5
        [
          [2,  if @up then 3 else 0] # 7
          [1,  if @up then 3 else 0] # 6 blue
          [0,  if @up then 1 else 1] # same
          [-1, if @up then 0 else 3] # 3
        ]
      when 3 # 6 blue
        [
          [1,  if @up then 9 else 1] # 
          [0,  if @up then 1 else 1] # 
          [-1, if @up then 0 else 9] # 
        ]
      when 4 # 7
        [
          [2,  if @up then 3 else 1] # 12 tonic
          [1,  if @up then 3 else 0] # 10
          [0,  if @up then 1 else 1] # same
          [-1, if @up then 0 else 3] # 6 blue
          [-1, if @up then 0 else 3] # 5
          [-4, if @up then 3 else 1] # 0 tonic
        ]
      when 5 # 10
        [
          [1,  if @up then 3 else 0] # tonic
          [0,  if @up then 1 else 1] # same
          [-1, if @up then 0 else 3] # 7
        ]
    @lastPitchIndex += Random.weightedChoose(chances)
    octave = Math.floor(@lastPitchIndex / @scale.length)
    return @scale[Util.mod(@lastPitchIndex, @scale.length)] + octave * 12 + @composer.key

module.exports = BluesSoloComposer
