should = require('chai').should()

{MetadataFormat} = require '../../src/metadata/metadata-format'

describe 'Metadata formats', ->

  expectedFormats = [
    'application/vnd.sdmx.structure+xml;version=2.1'
    'application/vnd.sdmx.structure+json;version=1.0.0'
  ]

  it 'contains all the expected formats and only those', ->
    count = 0
    for key, value of MetadataFormat
      expectedFormats.should.contain value
      count++
    count.should.equal expectedFormats.length + 1 # Shortcut for latest JSON

  it 'is immutable', ->
    MetadataFormat.should.be.frozen
