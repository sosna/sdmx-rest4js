should = require('chai').should()
{AvailabilityMode} = require('../../src/avail/availability-mode')

describe 'Availability modes', ->

  expectedTypes = [
    'exact'
    'available'
  ]

  it 'contains all the expected modes and only those', ->
    count = 0
    for key, value of AvailabilityMode
      expectedTypes.should.contain value
      count++
    count.should.equal expectedTypes.length

  it 'is immutable', ->
    AvailabilityMode.should.be.frozen
