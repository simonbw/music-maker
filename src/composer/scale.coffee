require "./chord.coffee"

Scale = {
  PENTATONIC_MAJOR: [0, 2, 4, 7, 9, 12]
  PENTATONIC_MINOR: [0, 3, 5, 7, 10, 12]
  BLUES_MAJOR: [0, 2, 3, 4, 7, 9, 12]
  BLUES_MINOR: [0, 3, 5, 6, 7, 10, 12]
  DIATONIC_MAJOR: [0, 2, 4, 5, 7, 9, 11, 12]
  DIATONIC_MINOR: [0, 2, 3, 5, 7, 8, 10, 12]
  WHOLE_TONE: [0, 2, 4, 6, 8, 10, 12]
  DIMINISHED: [0, 3, 6, 9, 12]
  CHROMATIC: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
}

module.exports = Scale