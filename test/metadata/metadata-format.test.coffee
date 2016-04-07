should = require('chai').should()

{MetadataFormat} = require '../../src/metadata/metadata-format'

describe 'Metadata formats', ->

  expectedFormats = [
    'application/vnd.sdmx.structure+xml;version=2.1'
  ]

  it 'contains all the expected formats and only those', ->
    count = 0
    for key, value of MetadataFormat
      expectedFormats.should.contain value
      count++
    count.should.equal expectedFormats.length

  it 'is immutable', ->
    MetadataFormat.should.be.frozen
