should = require('chai').should()

{ApiVersion} = require '../../src/utils/api-version'

describe 'API versions', ->

  expectedAPIs = [
    'v1.0.0'
    'v1.0.1'
    'v1.0.2'
    'v1.1.0'
    'v1.2.0'
    'latest'
  ]

  it 'contains all the expected versions and only those', ->
    count = 0
    for key, value of ApiVersion
      expectedAPIs.should.contain value
      count++
    count.should.equal expectedAPIs.length

  it 'is immutable', ->
    ApiVersion.should.be.frozen

  it 'considers v1.2.0 as the latest version', ->
    ApiVersion.LATEST.should.equal 'v1.2.0'
