
class Note
  @getFrequency: (pitch) ->
    return 440 * Math.pow(2, pitch / 12)

  constructor: (@pitch = 0) ->
    @duration = 1
    @attack = 0.7
    @subdivision = 0
    @frequency = Note.getFrequency(@pitch)
    @pitchBends = []

  setPitch: (value) ->
    @pitch = value
    return this

  setDuration: (value) ->
    if (value <= 0)
      throw new Error("Duration must be positive: #{value}")
    @duration = value
    return this

  setAttack: (value) ->
    @attack = value
    return this

  setSubdivision: (value) ->
    if value < 0 or value > 1
      throw new Error("Subdivision must be a number between 0 and 1: #{value}")
    @subdivision = value
    return this

  clone: () ->
    clone = new Note(@pitch)
    clone.duration = @duration
    clone.attack = @attack
    clone.subdivision = @subdivision
  
  # Add a pitch bend
  # 
  # @param start [number] time to start at
  # @param end [number]   time to end at
  # @param from [number]  semitones to bend from
  # @param to [number]    semitones to bend to
  addPitchBend: (start, end, from, to) ->
    # TODO: Guarantee no bad timing
    @pitchBends.push {
      start: start
      end: end
      from: from
      fromFrequency: Note.getFrequency(@pitch + from)
      to: to
      toFrequency: Note.getFrequency(@pitch + to)
    }
    return this

module.exports = Note
