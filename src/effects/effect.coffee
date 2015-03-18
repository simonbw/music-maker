Mixer = require('../mixer.coffee')

class Effect
  constructor: () ->
    @output = @input = Mixer.context.createGain()

module.exports = Effect