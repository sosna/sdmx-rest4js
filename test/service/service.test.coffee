should = require('chai').should()
assert = require('chai').assert

{ServiceType} = require '../../src/service/service-type.coffee'
{Service} = require '../../src/service/service.coffee'

describe 'Service', ->

  it 'should have the expected properties', ->
    service = new Service('http://test.com').build()
    service.should.be.an 'object'
    service.should.have.property 'id'
    service.should.have.property 'name'
    service.should.have.property 'api'
    service.should.have.property 'url'

  it 'should have the expected defaults', ->
    url = 'http://test.com'
    service = new Service(url).build()
    service.should.have.property('api').that.equals ServiceType.LATEST
    service.should.have.property('id').that.is.undefined
    service.should.have.property('name').that.is.undefined
    service.should.have.property('url').that.equals url

  it 'should be possible to set a provider', ->
    id = 'TEST'
    name = 'Test provider'

    service = new Service('http://test.com').provider(id).build()
    service.should.have.property('id').that.equals id
    service.should.have.property('name').that.is.undefined

    service = new Service('http://test.com').provider(id, name).build()
    service.should.have.property('id').that.equals id
    service.should.have.property('name').that.equals name

  it 'should be possible to set an API version', ->
    api = ServiceType.SDMX_REST_v1_0_0
    service = new Service('http://test.com').api(api).build()
    service.should.have.property('api').that.equals api

  it 'should not be possible to not set a url', ->
    try
      service = new Service().build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid service'
      error.message.should.contain 'url'

  it 'should not be possible to set an invalid API version', ->
    try
      service = new Service('http://test.com').api('test').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid service'
      error.message.should.contain 'versions of the SDMX RESTful API'

  it 'should be possible to get the default options', ->
    service = new Service('http://test.com')
    service.should.have.property 'defaults'
    service.defaults.should.have.property 'api'

  it 'should not be possible to change the default options', ->
    service = new Service('http://test.com')
    service.should.have.property 'defaults'
    service.defaults.should.be.frozen

  it 'should be possible to pass an object with options to create a service', ->
    opts =
      url: 'test.com'
      id: 'TEST'
    service = Service.from(opts)
    service.should.be.an 'object'
    service.should.have.property 'id'
    service.should.have.property 'name'
    service.should.have.property 'url'
    service.should.have.property 'api'
    service.id.should.equal opts.id
    service.url.should.equal opts.url
    service.should.have.property('name').that.is.undefined
    service.api.should.equal ServiceType.LATEST

  it 'should be possible to instantiate a service using its ID', ->
    service = Service.ECB
    service.should.be.an 'object'
    service.should.have.property('id').that.equals 'ECB'
    service.should.have.property('name').that.is.not.undefined
    service.should.have.property('url').that.is.not.undefined
    service.should.have.property('api').that.is.not.undefined
