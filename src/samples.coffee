Mixer = require "./mixer.coffee"

files = [
  "speakers/speaker_1.wav"
  "speakers/speaker_2.wav"
  "speakers/mod_us_1.wav"
  "speakers/mod_us_2.wav"
  "speakers/mod_us_3.wav"
  "speakers/mod_us_4.wav"
  "speakers/mod_uk_1.wav"
  "speakers/mod_uk_2.wav"
  "speakers/vin_us_1.wav"
  "speakers/vin_us_2.wav"
  "speakers/vin_uk_1.wav"
  "speakers/vin_uk_2.wav"
  "speakers/80s_uk_1.wav"
  "speakers/80s_uk_2.wav"
  "speakers/80s_us_1.wav"
  "speakers/80s_us_2.wav"
]

buffers = {}

class Samples
  @loadAll: (callback) ->
    toload = files.length

    if toload == 0
      console.log "no files to load"
      if callback
        callback()
      return

    files.forEach (filename) -> # don't use coffeescript for each because we want filename in scope
      request = new XMLHttpRequest()
      request.open('GET', "audio/#{filename}", true)
      request.responseType = 'arraybuffer'
      request.onload = ->
        console.log "#{filename} loaded"
        Mixer.context.decodeAudioData(request.response, (buffer) ->
          console.log "#{filename} decoded"
          buffers[filename] = buffer
          toload--
          if toload == 0 and callback
            console.log "all audio loaded"
            callback()
          )
      request.send()

  @get: (filename) ->
    return buffers[filename]

module.exports = Samples