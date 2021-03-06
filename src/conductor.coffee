Mixer = require "./mixer.coffee"

# Timing information about the current beat
class Beat
  constructor: (@start, @end) ->
    @length = @end - @start
    @samples = @length * Mixer.context.sampleRate

  getSubdivisionTime: (subdivision) ->
    return @start + subdivision * @length

# Controls timing
class Conductor
  SLEEP_TIME = 10 # Time in milliseconds to sleep between updates

  constructor: (@composer, @instruments) ->
    @playing = false
    @timeoutId = null
    @tempo = 120

  start: () =>
    console.log "Conductor starting"
    if !@playing
      @nextBeatTime = Mixer.context.currentTime
      @playing = true
      @update()

  update: () =>
    if @playing and Mixer.context.currentTime > @nextBeatTime
      @nextBeat()
    @timeoutId = setTimeout(@update, SLEEP_TIME)

  nextBeat: () =>
    data = @composer.nextBeat()
    if data['tempo']
      @tempo = data.tempo
      
    currentBeatTime = @nextBeatTime
    @nextBeatTime += 60 / @tempo
    beat = new Beat(currentBeatTime, @nextBeatTime)
    for instrument, notes of data
      if instrument == 'tempo'
        continue
      if notes is undefined
        console.log data
        throw new Error("undefined notes for #{instrument}")
      else
        for note in notes
          @instruments[instrument].play(note, beat)

  stop: () =>
    console.log "Conductor stopping"
    @playing = false
    if @timeoutId
      clearTimeout(@timeoutId)

module.exports = Conductor
