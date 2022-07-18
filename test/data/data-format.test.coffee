should = require('chai').should()

{DataFormat} = require '../../src/data/data-format'

describe 'Data formats', ->

  expected = [
    'application/vnd.sdmx.genericdata+xml;version=2.1'
    'application/vnd.sdmx.structurespecificdata+xml;version=2.1'
    'application/vnd.sdmx.generictimeseriesdata+xml;version=2.1'
    'application/vnd.sdmx.structurespecifictimeseriesdata+xml;version=2.1'
    'application/vnd.sdmx.data+xml;version=3.0.0'
    'application/vnd.sdmx.data+json;version=1.0.0-wd'
    'application/vnd.sdmx.data+json;version=1.0.0-cts'
    'application/vnd.sdmx.data+json;version=1.0.0'
    'application/vnd.sdmx.data+json;version=2.0.0'
    'application/vnd.sdmx.data+csv;version=1.0.0'
    'application/vnd.sdmx.data+csv;version=2.0.0'
    'application/vnd.sdmx.data+csv;version=1.0.0;labels=both'
    'application/vnd.sdmx.data+csv;version=1.0.0;timeFormat=normalized'
    'application/vnd.sdmx.data+csv;version=1.0.0;labels=both;timeFormat=normalized'
  ]

  it 'contains all the expected formats and only those', ->
    count = 0
    for key, value of DataFormat
      expected.should.contain value
      count++
    count.should.equal expected.length + 4 # 4 shortcuts to latest versions

  it 'is immutable', ->
    DataFormat.should.be.frozen
