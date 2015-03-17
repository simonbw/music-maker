Mixer = require "../mixer.coffee"

# Base class for all instruments
class Instrument
  # Create a new instrument
  constructor: (gain = 1.0) ->
    @output = Mixer.context.createGain()
    @output.gain.value = gain
    @chainStart = @output # the first node in the effects chain

  # Play a note
  play: (note, beat) ->
    # do something

module.exports = Instrument
