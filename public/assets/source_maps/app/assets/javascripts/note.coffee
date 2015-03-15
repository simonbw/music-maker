
class window.Note
  constructor: (@pitch = 0, @duration = 1, @attack = 0.7) ->
    @frequency = 440 * Math.pow(2, @pitch / 12)

  setDuration: (value) ->
    @duration = value
    return this

  setAttack: (value) ->
    @attack = value
    return this
