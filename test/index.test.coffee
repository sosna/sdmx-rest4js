sdmxrest = require '../src/index'
{ApiVersion} = require '../src/utils/api-version'
chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
should = chai.should()
nock = require 'nock'

describe 'API', ->

  it 'offers the expected functions and objects', ->
    sdmxrest.should.have.property 'getService'
    sdmxrest.should.have.property 'getDataQuery'
    sdmxrest.should.have.property 'getMetadataQuery'
    sdmxrest.should.have.property 'getUrl'
    sdmxrest.should.have.property 'request'
    sdmxrest.should.have.property('data').that.is.an 'object'
    sdmxrest.should.have.property('metadata').that.is.an 'object'
    sdmxrest.should.have.property('utils').that.is.an 'object'
    sdmxrest.should.have.property('data').that.is.an 'object'
    sdmxrest.data.should.have.property('DataFormat').that.is.not.undefined
    sdmxrest.data.should.have.property('DataDetail').that.is.not.undefined
    sdmxrest.metadata.should.have.property('MetadataDetail')
      .that.is.not.undefined
    sdmxrest.metadata.should.have.property('MetadataFormat')
      .that.is.not.undefined
    sdmxrest.metadata.should.have.property('MetadataReferences')
      .that.is.not.undefined
    sdmxrest.metadata.should.have.property('MetadataType').that.is.not.undefined
    sdmxrest.utils.should.have.property('ApiVersion').that.is.not.undefined
    sdmxrest.utils.should.have.property('SdmxPatterns').that.is.not.undefined
    sdmxrest.utils.SdmxPatterns.should.have.property('IDType')
      .that.is.a 'regexp'

  describe 'when using getService()', ->

    it 'offers to use existing services', ->
      service = sdmxrest.getService 'ECB'
      service.should.be.an 'object'
      service.should.have.property('id').that.equals 'ECB'
      service.should.have.property('name').that.equals 'European Central Bank'
      service.should.have.property('url').that.contains 'sdw-wsrest'
      service.should.have.property('api').that.is.not.undefined

    it 'offers to create services from properties', ->
      input = {
        id: 'TEST'
        url: 'http://test.com'
      }
      service = sdmxrest.getService input
      service.should.be.an 'object'
      service.should.have.property('id').that.equals input.id
      service.should.have.property('name').that.is.undefined
      service.should.have.property('url').that.equals input.url
      service.should.have.property('api').that.equals ApiVersion.LATEST

    it 'fails if the requested service is unknown', ->
      test = -> sdmxrest.getService 'UNKNOWN'
      should.Throw(test, ReferenceError,
        'is not in the list of predefined services')

    it 'fails if the input is not of the expected type', ->
      test = -> sdmxrest.getService 2
      should.Throw(test, TypeError, 'Invalid type of ')

      test = -> sdmxrest.getService undefined
      should.Throw(test, TypeError, 'Invalid type of ')

      test = -> sdmxrest.getService []
      should.Throw(test, TypeError, 'Invalid type of ')

  describe 'when using getDataQuery()', ->

    it 'offers to create a data query from properties', ->
      input = {
        flow: 'EXR'
        key: 'A..EUR.SP00.A'
      }
      query = sdmxrest.getDataQuery input
      query.should.be.an 'object'
      query.should.have.property('flow').that.equals input.flow
      query.should.have.property('key').that.equals input.key
      query.should.have.property('provider').that.equals 'all'
      query.should.have.property('start').that.is.undefined
      query.should.have.property('end').that.is.undefined
      query.should.have.property('updatedAfter').that.is.undefined
      query.should.have.property('firstNObs').that.is.undefined
      query.should.have.property('lastNObs').that.is.undefined
      query.should.have.property('obsDimension').that.equals 'TIME_PERIOD'
      query.should.have.property('detail').that.equals 'full'
      query.should.have.property('history').that.is.false

    it 'fails if the input is not of the expected type', ->
      test = -> sdmxrest.getDataQuery undefined
      should.Throw(test, Error, 'Not a valid data query')

      test = -> sdmxrest.getDataQuery {test: 'TEST'}
      should.Throw(test, Error, 'Not a valid data query')

  describe 'when using getMetadataQuery()', ->

    it 'offers to create a metadata query from properties', ->
      input = {
        resource: 'codelist'
        id: 'CL_FREQ'
      }
      query = sdmxrest.getMetadataQuery input
      query.should.be.an 'object'
      query.should.have.property('resource').that.equals input.resource
      query.should.have.property('id').that.equals input.id
      query.should.have.property('agency').that.equals 'all'
      query.should.have.property('version').that.equals 'latest'
      query.should.have.property('item').that.equals 'all'
      query.should.have.property('detail').that.equals 'full'
      query.should.have.property('references').that.equals 'none'

    it 'fails if the input is not of the expected type', ->
      test = -> sdmxrest.getMetadataQuery undefined
      should.Throw(test, Error, 'Not a valid metadata query')

      test = -> sdmxrest.getMetadataQuery {test: 'TEST'}
      should.Throw(test, Error, 'Not a valid metadata query')

  describe 'when using getUrl()', ->

    it 'offers to create a URL from a data query and a service objects', ->
      query = sdmxrest.getDataQuery {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}
      service = sdmxrest.getService 'ECB'
      url = sdmxrest.getUrl query, service
      url.should.be.a 'string'
      url.should.contain service.url
      url.should.contain query.flow
      url.should.contain query.key

    it 'offers to create a URL from a metadata query and a service objects', ->
      url = sdmxrest.getUrl {resource: 'codelist', id: 'CL_FREQ'}, 'ECB'
      url.should.be.a 'string'
      url.should.contain 'sdw-wsrest.ecb.europa.eu'
      url.should.contain 'codelist'
      url.should.contain 'CL_FREQ'

    it 'fails if the input is not of the expected type', ->
      test = -> sdmxrest.getUrl undefined, sdmxrest.getService 'ECB'
      should.Throw(test, Error, 'Not a valid query')

      query = sdmxrest.getDataQuery {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}
      test = -> sdmxrest.getUrl query, sdmxrest.getService 'TEST'
      should.Throw(test, Error, 'not in the list of predefined services')

      test = -> sdmxrest.getUrl query
      should.Throw(test, Error, 'Service is a mandatory parameter')

  describe 'when using execute()', ->

    it 'offers to execute a request from a query and service objects', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      opts = {headers: {'user-agent': 'test'}}
      response =
        sdmxrest.request {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}, 'ECB', opts
      response.should.eventually.equal 'OK'

    it 'offers to execute a request from an SDMX RESTful query string', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      response = sdmxrest.request 'http://sdw-wsrest.ecb.europa.eu/service/EXR'
      response.should.eventually.equal 'OK'

    it 'throws an exception in case of issues with a request', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('TEST') > -1)
        .reply 404
      response = sdmxrest.request {flow: 'TEST'}, 'ECB'
      response.should.be.rejectedWith RangeError

    it 'does not throw an exception for a 404 with updatedAfter', ->
      query = nock('http://stats.oecd.org')
        .get((uri) -> uri.indexOf('EO') > -1)
        .reply 404
      response = sdmxrest.request \
        {flow: 'EO', updatedAfter: '2016-01-01T14:54:27Z'}, 'OECD'
      response.should.be.fulfilled
      response.should.not.be.rejected

    it 'throws an exception when the Service URL is invalid', ->
      response = sdmxrest.request \
        {flow: 'ICP'}, {url: 'ws.test'}
      response.should.not.be.fulfilled
      response.should.be.rejected
