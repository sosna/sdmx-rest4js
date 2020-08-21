should = require('chai').should()

{SchemaFormat} = require '../../src/schema/schema-format'

describe 'Schema formats', ->

  expectedFormats = [
    'application/vnd.sdmx.structure+xml;version=2.1'
    'application/vnd.sdmx.structure+json;version=1.0.0'
    'application/xml'
  ]

  it 'contains all the expected formats and only those', ->
    count = 0
    for key, value of SchemaFormat
      expectedFormats.should.contain value
      count++
    count.should.equal expectedFormats.length + 2 # Shortcut for latests

  it 'is immutable', ->
    SchemaFormat.should.be.frozen
