should = require('chai').should()

{ServiceTypes} = require '../src/service-types.coffee'

describe 'Service types', ->

  expectedServices = [
    'sdmx-rest-v1.0.0'
    'sdmx-rest-v1.0.1'
    'sdmx-rest-v1.0.2'
    'sdmx-rest-v1.1.0'
  ]

  it 'should contain all expected service types and only those', ->
    count = 0
    for key, value of ServiceTypes
      expectedServices.should.contain value
      count++
    count.should.equal expectedServices.length

  it 'should be immutable', ->
    ServiceTypes.should.be.frozen
