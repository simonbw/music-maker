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

  getAttackTime: (note) ->
    return @attackTime

module.exports = OscillatorInstrument