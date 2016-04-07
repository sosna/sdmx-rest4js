should = require('chai').should()

{MetadataDetail} = require '../../src/metadata/metadata-detail'

describe 'Metadata detail', ->

  expectedDetails = [
    'full'
    'referencestubs'
    'allstubs'
  ]

  it 'contains all the expected details and only those', ->
    count = 0
    for key, value of MetadataDetail
      expectedDetails.should.contain value
      count++
    count.should.equal expectedDetails.length

  it 'is immutable', ->
    MetadataDetail.should.be.frozen
