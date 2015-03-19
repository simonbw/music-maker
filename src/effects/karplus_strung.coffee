Mixer = require "../mixer.coffee"

# TODO: Actually implement this. It doesn't work right now.
class KarplusStrung
  constructor: (@N) ->
    @input = @output = @processor = Mixer.context.createScriptProcessor(0, 1, 1)
    
    @n = 0
    @ringBuffer = Mixer.getBuffer()

    @processor.onaudioprocess = @process
      


  getN: (time) =>
    return @N

  process: (e) => 
    inputData = e.inputBuffer.getChannelData(0)
    outputData = e.outputBuffer.getChannelData(0)

    ringBuffer = @ringBuffer
    for i in [0...outputData.length]
      outputData[i] = inputData[i]

    n = @n
    N = @getN(Mixer.context.currentTime)

    for (var i = 0; i < e.outputBuffer.length; ++i) {
      outputData[i] = 

      if (++n >= N) n = 0;
    }
    @n = n

module.exports = KarplusStrung