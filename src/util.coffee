# Various utility functions
class Util
  @connectAll: (nodes...) ->
    last = null
    for node in nodes
        
      if last
        if node.input # custom nodes
          last.connect(node.input)
        else
          last.connect(node)
      last = node

  @mod: (value, divisor) ->
    return ((value % divisor) + divisor) % divisor
  
  @clamp: (value, min=0, max=1) ->
    return Math.max(Math.min(value, max), min)

  @randomPitch: (min, max) ->
    return Math.floor((Math.random() * (max - min)) + min)
    
  @partialsWithDecay: (data, phase, decay) ->
    result = 0.0
    for d in data
      result += Math.sin(d.frequency * phase) * Math.max(1 - decay * d.decay, 0) * d.volume;
    return result

module.exports = Util
