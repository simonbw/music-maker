Mixer = require "../mixer.coffee"
Instrument = require "./instrument.coffee"

class OscillatorInstrument extends Instrument
  constructor: (gain, @oscillatorType='sine', @attackTime=0.01) ->
    super(gain)

  play: (note, beat) ->
    startTime = beat.getSubdivisionTime(note.subdivision)
    endTime = startTime + note.duration * beat.length
    
    oscillator = @makeOscillator(note)

    gainNode = Mixer.context.createGain()
    gainNode.connect(@chainStart)
    oscillator.connect(gainNode)
    
    @doGain(note, gainNode, startTime, endTime)
    @doPitchbends(note, beat, oscillator, startTime, endTime)

    oscillator.start(startTime)
    oscillator.stop(endTime)

  makeOscillator: (note) ->
    oscillator = Mixer.context.createOscillator()
    oscillator.frequency.value = note.frequency
    oscillator.type = @oscillatorType
    return oscillator

  doGain: (note, gainNode, startTime, endTime) ->
    gainNode.gain.setValueAtTime(0, startTime)
    gainNode.gain.linearRampToValueAtTime(note.attack, startTime + @getAttackTime(note))
    gainNode.gain.linearRampToValueAtTime(0, endTime)

  doPitchbends: (note, beat, oscillator, startTime, endTime) ->
    for bend in note.pitchBends
      start = startTime + bend.start * note.duration * beat.length
      end = startTime + bend.end * note.duration * beat.length
      oscillator.frequency.setValueAtTime(bend.fromFrequency, start)
      oscillator.frequency.linearRampToValueAtTime(bend.toFrequency, end)

  getAttackTime: (note) ->
    return @attackTime

module.exports = OscillatorInstrument