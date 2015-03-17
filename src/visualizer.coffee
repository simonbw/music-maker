

class window.Visualizer
  constructor: (bars = 8) ->
    @input = @analyser = Mixer.context.createAnalyser()
    @element = $('<div>').addClass('visualizer')

    @analyser.smoothing

    for i in [0..bars]
      bar = $('<div>').addClass('bar')
      @element.append(bar)

    @buffer = new Uint8Array(@analyser.frequencyBinCount)
    requestAnimationFrame(@update)


  update: () =>
    buffer = @buffer
    dataPerBar = @buffer.length / @element.find('.bar').length

    @analyser.getByteFrequencyData(@buffer)
    @element.find('.bar').each ->
      i = $(this).index()
      
      value = 0
      start = Math.floor((i * dataPerBar))
      end = start + Math.floor(dataPerBar)
      for j in [start..end]
        value = Math.max(buffer[j] / 256, value)
      # value = value / (256 * Math.floor(dataPerBar + 1))

      if value > 0.95
        color = '#F00'
      else if value > 0.85
        color = '#FA0'
      else if value > 0.75
        color = '#FF0'
      else
        color = '#0F0'

      $(this).height("#{value * 100}%")
      $(this).css("background-color", color)
    
    requestAnimationFrame(@update)
