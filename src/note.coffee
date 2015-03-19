
class Note
  constructor: (@pitch = 0) ->
    @duration = 1
    @attack = 0.7
    @subdivision = 0
    @frequency = 440 * Math.pow(2, @pitch / 12)

  setPitch: (value) ->
    @pitch = value
    return this

  setDuration: (value) ->
    if (value <= 0)
      throw new Error("Duration must be positive: #{value}")
    @duration = value
    return this

  setAttack: (value) ->
    @attack = value
    return this

  setSubdivision: (value) ->
    if value < 0 or value > 1
      throw new Error("Subdivision must be a number between 0 and 1: #{value}")
    @subdivision = value
    return this

  clone: () ->
    clone = new Note(@pitch)
    clone.duration = @duration
    clone.attack = @attack
    clone.subdivision = @subdivision
    
module.exports = Note
