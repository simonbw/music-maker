Mixer = require "../mixer.coffee"
Util = require "../util.coffee"
Effect = require "./effect.coffee"
Samples = require "../samples.coffee"
SimpleReverb = require "./simple_reverb.coffee"
SimpleEQ = require "./simple_eq.coffee"

# Speaker cabinet
class Cabinet extends Effect
  constructor: () ->
    super()

    @convolver = Mixer.context.createConvolver()
    @convolver.buffer = Samples.get('speakers/mod_uk_2.wav')
    
    Util.connectAll(@wet, @convolver, @output)

module.exports = Cabinet
