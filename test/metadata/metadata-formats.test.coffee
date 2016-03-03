should = require('chai').should()

{MetadataFormats} = require '../../src/metadata/metadata-formats.coffee'

describe 'Metadata formats', ->

  expectedFormats = [
    'application/vnd.sdmx.structure+xml;version=2.1'
  ]

  it 'should contain all expected formats and only those', ->
    count = 0
    for key, value of MetadataFormats
      expectedFormats.should.contain value
      count++
    count.should.equal expectedFormats.length

  it 'should be immutable', ->
    MetadataFormats.should.be.frozen
