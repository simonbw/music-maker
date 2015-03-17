# Various random functions
class Random

  @uniform: (a, b) ->
    if b is undefined
      b = a
      a = 0
    return Math.random() * (b - a) + a

  @int: (a, b) ->
    return Math.floor(@uniform(a, b))

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

module.exports = Random