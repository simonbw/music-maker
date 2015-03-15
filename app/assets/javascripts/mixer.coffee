class window.Mixer
  @context = new AudioContext()
  @output = @context.createGain()
  @output.connect(@context.destination)

  @getMillisecondsPerBeat: ->
    return 1000 / (@tempo / 60)

  @getSamplesPerBeat: ->
    return @context.sampleRate / (@tempo / 60)

  @setTempo: (value, subdivisions = 4) ->
    @tempo = value * subdivisions

  @setTempo(120)