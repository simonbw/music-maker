
class Mixer
  @context = new AudioContext()
  @output = @context.createGain()
  @output.connect(@context.destination)

  @getMillisecondsPerBeat: ->
    return 1000 / (@tempo / 60)

  @getSamplesPerBeat: ->
    return @context.sampleRate / (@tempo / 60)

  @setTempo: (value, subdivisions = 4) ->
    @tempo = value * subdivisions

  @getBuffer: (length = 1.0, channels = 1) ->
    samples = Math.ceil(@context.sampleRate * length)
    return @context.createBuffer(channels, samples, @context.sampleRate)

  @setTempo(120)


module.exports = Mixer
