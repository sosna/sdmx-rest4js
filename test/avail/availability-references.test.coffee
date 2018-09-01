should = require('chai').should()
{AvailabilityReferences} = require('../../src/avail/availability-references')

describe 'Availability references', ->

  expectedReferences = [
    'datastructure'
    'conceptscheme'
    'codelist'
    'dataproviderscheme'
    'dataflow'
    'none'
    'all'
  ]

  it 'contains all the expected references and only those', ->
    count = 0
    for key, value of AvailabilityReferences
      expectedReferences.should.contain value
      count++
    count.should.equal expectedReferences.length

  it 'is immutable', ->
    AvailabilityReferences.should.be.frozen
