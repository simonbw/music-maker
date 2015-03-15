# Various utility functions 
class window.Util

  @randomPitch: (min, max) ->
    return Math.floor((Math.random() * (max - min)) + min)
    
  @partialsWithDecay: (data, phase, decay) ->
    result = 0.0
    for d in data
      result += Math.sin(d.frequency * phase) * Math.max(1 - decay * d.decay, 0) * d.volume;
    return result


# Various random functions
class window.Random

  @uniform: (a, b) ->
    if b is undefined
      b = a
      a = 0
    return Math.random() * (b - a) + a

  # Choose a random element from an array
  @choose: (options) ->
    return options[Math.floor(Math.random() * options.length)]

  # Given an array of pairs of elements and weights, choose a random elements
  @weightedChoose: (options) ->
    totalWeight = 0
    for option in options
      totalWeight += option[1]
    
    weightIndex = 0
    weightThreshold = Math.random() * totalWeight
    for option in options      
      weightIndex += option[1]
      if weightIndex > weightThreshold
        return option[0]