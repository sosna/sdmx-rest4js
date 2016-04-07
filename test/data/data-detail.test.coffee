should = require('chai').should()

{DataDetail} = require '../../src/data/data-detail'

describe 'Data detail', ->

  expectedDetails = [
    'full'
    'dataonly'
    'serieskeysonly'
    'nodata'
  ]

  it 'contains all the expected details and only those', ->
    count = 0
    for key, value of DataDetail
      expectedDetails.should.contain value
      count++
    count.should.equal expectedDetails.length

  it 'is immutable', ->
    DataDetail.should.be.frozen
