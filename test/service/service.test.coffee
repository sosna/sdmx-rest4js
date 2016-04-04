should = require('chai').should()
assert = require('chai').assert
expect = require('chai').expect()

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
    api = ApiVersion.v1_0_0
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

  it 'should be possible to use predefined services', ->
    all = [
      'ECB'
      'ECB_S'
      'SDMXGR'
      'SDMXGR_S'
      'EUROSTAT'
      'OECD'
      'OECD_S'
    ]
    Service[s].should.be.an 'object' for s in all
    Service[s].should.have.property('id').that.is.not.undefined for s in all
    Service[s].should.have.property('name').that.is.not.undefined for s in all
    Service[s].should.have.property('url').that.is.not.undefined for s in all
    Service[s].should.have.property('api').that.is.not.undefined for s in all
    Service[s].should.have.property('url').that.is.not.undefined for s in all
    Service[s].url.should.contain 'http' for s in all when s.indexOf '_S' is -1
    Service[s].url.should.contain 'https' for s in all when s.indexOf('_S') > -1

  it 'should give access to services over both http and https', ->
    s1 = Service.ECB
    s2 = Service.ECB_S
    s1.should.be.an 'object'
    s2.should.be.an 'object'
    s1.should.have.property('id').that.equals 'ECB'
    s2.should.have.property('id').that.equals 'ECB'
    s1.should.have.property('name').that.equals s2.name
    s1.should.have.property('api').that.equals s2.api
    s1.should.have.property('url').that.contains 'http://'
    s2.should.have.property('url').that.contains 'https://'
