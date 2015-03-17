
class window.DrumComposer
  SPEED_NORMAL = 'normal'
  SPEED_DOUBLE = 'double'
  SPEED_HALF = 'half'

  constructor: () ->
    @groove = []
    @smallFill = [] # half bar
    @bigFill = [] # full bar
    
    @speed = SPEED_NORMAL
    @hihatRate = 0
    @hihatOffset = 0

  nextSmallFill: () ->
    @smallFill = @makeFill(Composer.BEATS_PER_BAR / 2)

  nextBigFill: () ->
    @bigFill = @makeFill(Composer.BEATS_PER_BAR)

  nextGroove: () ->
    options = [
      [SPEED_NORMAL, 3]
      [SPEED_DOUBLE, 1 + 1.0 * (@speed == SPEED_DOUBLE) - 0.9 * (@speed == SPEED_HALF)]
      [SPEED_HALF, 1 - 0.9 * (@speed == SPEED_DOUBLE) + 1.0 * (@speed == SPEED_HALF)]
    ]
    @speed = Random.weightedChoose(options)

    @doubletime = Math.random() < 0.2 - @halftime * 0.15
    @halftime = !@doubletime and Math.random() < 0.25 + @halftime * 0.2
    @groove = @makeGroove(Composer.BEATS_PER_BAR, @speed)

  makeFill: (length) ->
    length ?= Composer.BEATS_PER_BAR

    fill = []
    speedModifier = switch @speed
      when SPEED_NORMAL then 1
      when SPEED_DOUBLE then 1.3
      when SPEED_HALF then 0.6
    
    for i in [0..length]
      notes = []
      if Math.random() < 0.3 * (1 + 0.5 * i / length) * speedModifier
        attack = 0.6 + 0.3 * (i / length) + Random.uniform(0.1)
        notes.push(new Note(Drumset.SNARE).setAttack(attack))
      else if Math.random() < 0.7 * (1 + 0.5 * i / length) * speedModifier
        attack = 0.7 + 0.2 * (i / length) + Random.uniform(0.1)
        notes.push(new Note(Drumset.BASS).setAttack(attack))
      fill.push(notes)

      @addHihat(notes, i)

    return fill

  makeGroove: (length, speed) ->
    length ?= Composer.BEATS_PER_BAR
    speed ?= @speed

    groove = []

    @hihatRate = 0
    @hihatOffset = 0
    switch speed
      when SPEED_DOUBLE
        if Math.random() < 0.5
          @hihatRate = 1
        else if Math.random() < 0.7
          @hihatRate = 2
      when SPEED_NORMAL
        if Math.random() < 0.9
          @hihatRate = 2
      when SPEED_HALF
        if Math.random() < 0.9
          @hihatRate = 4
          if Math.random() < 0.4
            @hihatOffset = 2

    for i in [0..Composer.BEATS_PER_BAR]
      notes = []

      bassChance = 0
      snareChance = 0

      switch speed
        when SPEED_DOUBLE
          bassChance = 0.2
          snareChance = 0.01
          if (i == 0)
            bassChance += 0.4
          if (i % 8 == 0)
            bassChance += 0.2

          if (i % 4 == 2)
            snareChance += 0.97
        when SPEED_NORMAL
          bassChance = 0.1
          snareChance = 0.01

          if (i == 0)
            bassChance += 0.5
          if (i % 8 == 0)
            bassChance += 0.2

          if (i % 8 == 4)
            snareChance += 0.9
          if (i == 7 || i == 9)
            snareChance += 0.1
        when SPEED_HALF
          bassChance = 0.1
          snareChance = 0.01

          if (i == 0)
            bassChance += 0.5
          if (i % 4 == 0)
            bassChance += 0.1

          if (i == 8)
            snareChance += 0.7

      @addHihat(notes, i)

      if Math.random() < snareChance
        notes.push(new Note(Drumset.SNARE))
      else if Math.random() < bassChance
        notes.push(new Note(Drumset.BASS))
    
      groove.push(notes)

    return groove

  addHihat: (notes, i, addHihat, rate, offset) ->
    rate ?= @hihatRate
    offset ?= @hihatOffset
    if rate and (i % rate == offset)
      attack = @getAttack(i)
      notes.push(new Note(Drumset.HIHAT).setAttack(attack))

  getAttack: (i, base = 0.55, halfs = 0.15, quarters = 0.15, eighths = 0.15) ->
    attack = base
    if (i % 8 == 0) then attack += halfs
    if (i % 4 == 0) then attack += quarters
    if (i % 2 == 0) then attack += eighths
    return attack