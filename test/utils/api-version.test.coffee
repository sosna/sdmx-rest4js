should = require('chai').should()

{ApiVersion} = require '../../src/utils/api-version'

describe 'Service types', ->

  expectedServices = [
    'sdmx-rest-v1.0.0'
    'sdmx-rest-v1.0.1'
    'sdmx-rest-v1.0.2'
    'sdmx-rest-v1.1.0'
  ]

  it 'should contain all expected service types and only those', ->
    count = 0
    for key, value of ApiVersion
      expectedServices.should.contain value
      count++
    count.should.equal expectedServices.length + 1 # takes latest into account

  it 'should be immutable', ->
    ApiVersion.should.be.frozen
