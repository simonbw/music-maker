
class window.Note
  constructor: (@pitch = 0) ->
    @duration = 1
    @attack = 0.7
    @subdivision = 0
    @frequency = 440 * Math.pow(2, @pitch / 12)

  setPitch: (value) ->
    @pitch = value
    return this

  setDuration: (value) ->
    @duration = value
    return this

  setAttack: (value) ->
    @attack = value
    return this

  setSubdivision: (value) ->
    @subdivision = value
    return this