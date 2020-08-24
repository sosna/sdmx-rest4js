should = require('chai').should()

{ApiVersion} = require '../../src/utils/api-version'
{Service} = require '../../src/service/service'
{DataFormat} = require '../../src/data/data-format'
{services} = require '../../src/service/service'
{MetadataFormat} = require '../../src/metadata/metadata-format'

describe 'Service', ->

  it 'has the expected properties', ->
    service = Service.from({url: 'http://test.com'})
    service.should.be.an 'object'
    service.should.include.keys ['id','name','api','url','format','structureFormat']

  it 'has the expected defaults', ->
    url = 'http://test.com'
    service = Service.from({url: url})
    service.should.have.property('api').that.equals ApiVersion.LATEST
    service.should.have.property('id').that.is.undefined
    service.should.have.property('name').that.is.undefined
    service.should.have.property('url').that.equals url
    service.should.have.property('format').that.is.undefined
    service.should.have.property('structureFormat').that.is.undefined

  context 'when passing an object', ->

    it 'allows setting a provider', ->
      id = 'TEST'
      name = 'Test provider'

      service = Service.from({url: 'http://test.com', id: id})
      service.should.have.property('id').that.equals id
      service.should.have.property('name').that.is.undefined

      service = Service.from({url: 'http://test.com', id: id, name: name})
      service.should.have.property('id').that.equals id
      service.should.have.property('name').that.equals name

    it 'allows settings an API version', ->
      api = ApiVersion.v1_0_0
      service = Service.from({url: 'http://test.com', api: api})
      service.should.have.property('api').that.equals api

    it 'throws an exception if the API version unknown', ->
      test = -> Service.from({url: 'http://test.com', api: 'test'})
      should.Throw(test, Error, 'versions of the SDMX RESTful API')

    it 'throws an exception if the url is missing', ->
      test = -> Service.from({})
      should.Throw(test, Error, 'url')

    it 'throws an exception if there is no input ', ->
      test = -> Service.from()
      should.Throw(test, Error, 'url')

  context 'when passing an string', ->

    it 'offers access to predefined services', ->
      i = [
        'ECB'
        'ECB_S'
        'SDMXGR'
        'SDMXGR_S'
        'EUROSTAT'
        'OECD'
        'OECD_S'
        'WB'
      ]
      Service[s].should.be.an 'object' for s in i
      Service[s].should.have.property('id').that.is.not.undefined for s in i
      Service[s].should.have.property('name').that.is.not.undefined for s in i
      Service[s].should.have.property('url').that.is.not.undefined for s in i
      Service[s].should.have.property('api').that.is.not.undefined for s in i
      Service[s].should.have.property('url').that.is.not.undefined for s in i
      Service[s].url.should.contain 'http' for s in i when s.indexOf '_S' is -1
      Service[s].url.should.contain 'https' for s in i when s.indexOf('_S') > -1

    it 'offers a default data format for some predefined services', ->
      format = DataFormat.SDMX_JSON_1_0_0_WD
      Service['ECB'].should.have.property('format').that.equals format

    it 'offers a default metadata format for some predefined services', ->
      format = MetadataFormat.SDMX_ML_2_1_STRUCTURE
      Service['ECB'].should.have.property('structureFormat').that.equals format

    it 'offers access to secure instances of predefined services', ->
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

describe 'Services', ->

  it 'list some services', ->
    services.should.be.an 'array'
    services.should.have.property('length').that.is.gte 5

  it 'should contain a few known services', ->
    services.should.include.members([Service.ECB_S, Service.SDMXGR_S])
