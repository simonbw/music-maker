Note = require '../note.coffee'
Random = require "../random.coffee"
Scale = require "./scales.coffee"
Util = require "../util.coffee"

class BluesSoloComposer
  UP = true
  DOWN = false

  constructor: (@composer) ->
    @scale = Scale.BLUES_MINOR
    @last = Random.int(@scale.length)
    @direction = Random.bit()

  getBeat: () ->
    notes = []
    switch Random.int(4)
      when 0
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.8)
            .setDuration(2 / 3))
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.6)
            .setSubdivision(2 / 3)
            .setDuration(1 / 3))
      when 1
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.8)
            .setDuration(1 / 3))
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.6)
            .setSubdivision(1 / 3)
            .setDuration(1 / 3))
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.6)
            .setSubdivision(2 / 3)
            .setDuration(1 / 3))
      when 2
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.7)
            .setDuration(1))
      when 3
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.8)
            .setDuration(1 / 6))
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.6)
            .setSubdivision(1 / 6)
            .setDuration(1 / 6))
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.6)
            .setSubdivision(2 / 6)
            .setDuration(1 / 6))
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.6)
            .setSubdivision(3 / 6)
            .setDuration(1 / 6))
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.6)
            .setSubdivision(4 / 6)
            .setDuration(1 / 6))
        notes.push(
          new Note(@nextPitch())
            .setAttack(0.6)
            .setSubdivision(5 / 6)
            .setDuration(1 / 6))

    return notes

  nextPitch: () ->
    upChance = 0.1 + @direction * 0.8
    upChance -= @last / 30
    @direction = Random.bit(upChance)
    console.log (if @direction then "up" else "down")

    variation = 0.3
    chance = @direction ? 1 - variation : 0 + variation
    @last += Random.sign(chance)
    octave = Math.floor(@last / @scale.length)
    return Scale.BLUES_MINOR[Util.mod(@last, @scale.length)] + octave * 12

module.exports = BluesSoloComposer
