
# TODO: Actually implement this. It doesn't work right now.
class window.KarplusStrung
  constructor: (@N) ->
    @input = @output = @processor = Mixer.context.createScriptProcessor(0, 1, 1)
    @processor.onaudioprocess = @process

  process: (e) => 
    inputData = e.inputBuffer.getChannelData(0)
    outputData = e.outputBuffer.getChannelData(0)

    for i in [0..outputData.length]
      outputData[i] = inputData[i]
