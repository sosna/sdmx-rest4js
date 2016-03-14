should = require('chai').should()
assert = require('chai').assert

{ApiVersion} = require '../../src/utils/api-version'
{Service} = require '../../src/service/service'

describe 'Service', ->

  it 'should have the expected properties', ->
    service = Service.from({url: 'http://test.com'})
    service.should.be.an 'object'
    service.should.have.property 'id'
    service.should.have.property 'name'
    service.should.have.property 'api'
    service.should.have.property 'url'

  it 'should have the expected defaults', ->
    url = 'http://test.com'
    service = Service.from({url: url})
    service.should.have.property('api').that.equals ApiVersion.LATEST
    service.should.have.property('id').that.is.undefined
    service.should.have.property('name').that.is.undefined
    service.should.have.property('url').that.equals url

  it 'should be possible to set a provider', ->
    id = 'TEST'
    name = 'Test provider'

    service = Service.from({url: 'http://test.com', id: id})
    service.should.have.property('id').that.equals id
    service.should.have.property('name').that.is.undefined

    service = Service.from({url: 'http://test.com', id: id, name: name})
    service.should.have.property('id').that.equals id
    service.should.have.property('name').that.equals name

  it 'should be possible to set an API version', ->
    api = ApiVersion.SDMX_REST_v1_0_0
    service = Service.from({url: 'http://test.com', api: api})
    service.should.have.property('api').that.equals api

  it 'should not be possible to not set a url', ->
    try
      service = Service.from({})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid service'
      error.message.should.contain 'url'

  it 'should not be possible to set an invalid API version', ->
    try
      service = Service.from({url: 'http://test.com', api: 'test'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid service'
      error.message.should.contain 'versions of the SDMX RESTful API'

  it 'should be possible to instantiate a service using its ID', ->
    service = Service.ECB
    service.should.be.an 'object'
    service.should.have.property('id').that.equals 'ECB'
    service.should.have.property('name').that.is.not.undefined
    service.should.have.property('url').that.is.not.undefined
    service.should.have.property('api').that.is.not.undefined
