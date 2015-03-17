# Various utility functions 
class Util

  @randomPitch: (min, max) ->
    return Math.floor((Math.random() * (max - min)) + min)
    
  @partialsWithDecay: (data, phase, decay) ->
    result = 0.0
    for d in data
      result += Math.sin(d.frequency * phase) * Math.max(1 - decay * d.decay, 0) * d.volume;
    return result

module.exports = Util