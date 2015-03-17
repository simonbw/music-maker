Mixer = require './mixer.coffee'

class Visualizer
  constructor: (bars = 8) ->
    @input = @analyser = Mixer.context.createAnalyser()
    @element = document.createElement('div')
    @element.classList.add('visualizer')

    @analyser.smoothing

    for i in [0..bars]
      bar = document.createElement('div')
      bar.classList.add('bar')
      @element.appendChild(bar)

    @buffer = new Uint8Array(@analyser.frequencyBinCount)
    requestAnimationFrame(@update)


  update: () =>
    buffer = @buffer
    bars = @element.querySelectorAll('.bar')
    dataPerBar = @buffer.length / bars.length

    @analyser.getByteFrequencyData(@buffer)

    for i in [0...bars.length]
      value = 0
      start = Math.floor((i * dataPerBar))
      end = start + Math.floor(dataPerBar)
      for j in [start..end]
        value = Math.max(buffer[j] / 256, value)

      bars[i].style.height = "#{value * 100}%"

      if value > 0.95
        color = '#F00'
      else if value > 0.85
        color = '#FA0'
      else if value > 0.75
        color = '#FF0'
      else
        color = '#0F0'
      bars[i].style.backgroundColor = color
    requestAnimationFrame(@update)

module.exports = Visualizer