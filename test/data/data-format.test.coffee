should = require('chai').should()

{DataFormat} = require '../../src/data/data-format'

describe 'Data formats', ->

  expected = [
    'application/vnd.sdmx.genericdata+xml;version=2.1'
    'application/vnd.sdmx.structurespecificdata+xml;version=2.1'
    'application/vnd.sdmx.generictimeseriesdata+xml;version=2.1'
    'application/vnd.sdmx.structurespecifictimeseriesdata+xml;version=2.1'
    'application/vnd.sdmx.data+json;version=1.0.0-wd'
    'application/vnd.sdmx.data+json;version=1.0.0-cts'
  ]

  it 'should contain all expected formats and only those', ->
    count = 0
    for key, value of DataFormat
      expected.should.contain value
      count++
    count.should.equal expected.length + 3 # 3 shortcuts to latest versions

  it 'should be immutable', ->
    DataFormat.should.be.frozen
