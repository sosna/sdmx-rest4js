should = require('chai').should()

{ServiceType} = require '../../src/service/service-type.coffee'

describe 'Service types', ->

  expectedServices = [
    'sdmx-rest-v1.0.0'
    'sdmx-rest-v1.0.1'
    'sdmx-rest-v1.0.2'
    'sdmx-rest-v1.1.0'
  ]

  it 'should contain all expected service types and only those', ->
    count = 0
    for key, value of ServiceType
      expectedServices.should.contain value
      count++
    count.should.equal expectedServices.length + 1 # takes latest into account

  it 'should be immutable', ->
    ServiceType.should.be.frozen
