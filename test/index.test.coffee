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
    sdmxrest.should.have.property('services').that.is.an 'array'
    sdmxrest.should.have.property 'getDataQuery'
    sdmxrest.should.have.property 'getMetadataQuery'
    sdmxrest.should.have.property 'getAvailabilityQuery'
    sdmxrest.should.have.property 'getSchemaQuery'
    sdmxrest.should.have.property 'getUrl'
    sdmxrest.should.have.property 'request'
    sdmxrest.should.have.property 'checkStatus'
    sdmxrest.should.have.property 'checkMediaType'
    sdmxrest.should.have.property('data').that.is.an 'object'
    sdmxrest.should.have.property('metadata').that.is.an 'object'
    sdmxrest.should.have.property('availability').that.is.an 'object'
    sdmxrest.should.have.property('schema').that.is.an 'object'
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
    sdmxrest.availability.should.have.property('AvailabilityMode')
      .that.is.not.undefined
    sdmxrest.availability.should.have.property('AvailabilityReferences')
      .that.is.not.undefined
    sdmxrest.metadata.should.have.property('MetadataType').that.is.not.undefined
    sdmxrest.schema.should.have.property('SchemaContext').that.is.not.undefined
    sdmxrest.utils.should.have.property('ApiVersion').that.is.not.undefined
    sdmxrest.utils.should.have.property('ApiResources').that.is.not.undefined
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

  describe 'when using services', ->

    it 'list some services', ->
      sdmxrest.services.should.be.an 'array'
      sdmxrest.services.should.have.property('length').that.is.gte 5

    it 'should contain known services', ->
      sdmxrest.services.should.include.members([sdmxrest.getService 'ECB_S'])

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
      query.should.have.property('obsDimension').that.is.undefined
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

  describe 'when using getAvailabilityQuery()', ->

    it 'offers to create an availability query from properties', ->
      input = {
        flow: 'EXR'
        key: 'A..EUR.SP00.A'
      }
      query = sdmxrest.getAvailabilityQuery input
      query.should.be.an 'object'
      query.should.have.property('flow').that.equals input.flow
      query.should.have.property('key').that.equals input.key
      query.should.have.property('provider').that.equals 'all'
      query.should.have.property('component').that.equals 'all'
      query.should.have.property('start').that.is.undefined
      query.should.have.property('end').that.is.undefined
      query.should.have.property('updatedAfter').that.is.undefined
      query.should.have.property('mode').that.equals 'exact'
      query.should.have.property('references').that.equals 'none'

    it 'fails if the input is not of the expected type', ->
      test = -> sdmxrest.getAvailabilityQuery undefined
      should.Throw(test, Error, 'Not a valid availability query')

      test = -> sdmxrest.getAvailabilityQuery {test: 'TEST'}
      should.Throw(test, Error, 'Not a valid availability query')

  describe 'when using getSchemaQuery()', ->

    it 'offers to create a schema query from properties', ->
      input = {
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
      }
      query = sdmxrest.getSchemaQuery input
      query.should.be.an 'object'
      query.should.have.property('context').that.equals input.context
      query.should.have.property('id').that.equals input.id
      query.should.have.property('agency').that.equals input.agency
      query.should.have.property('version').that.equals 'latest'
      query.should.have.property('explicit').that.is.false
      query.should.have.property('obsDimension').that.is.undefined

    it 'fails if the input is not of the expected type', ->
      test = -> sdmxrest.getSchemaQuery undefined
      should.Throw(test, Error, 'Not a valid schema query')

      test = -> sdmxrest.getSchemaQuery {test: 'TEST'}
      should.Throw(test, Error, 'Not a valid schema query')

  describe 'when using getUrl()', ->

    it 'creates a URL from a data query and a service objects', ->
      query = sdmxrest.getDataQuery {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}
      service = sdmxrest.getService 'ECB'
      url = sdmxrest.getUrl query, service
      url.should.be.a 'string'
      url.should.contain service.url
      url.should.contain query.flow
      url.should.contain query.key

    it 'creates a URL from a metadata query and a service objects', ->
      url = sdmxrest.getUrl {resource: 'codelist', id: 'CL_FREQ'}, 'ECB'
      url.should.be.a 'string'
      url.should.contain 'sdw-wsrest.ecb.europa.eu'
      url.should.contain 'codelist'
      url.should.contain 'CL_FREQ'

    it 'creates a URL from a schema query and a service objects', ->
      q = {'context': 'dataflow', 'agency': 'BIS', 'id': 'CBS'}
      url = sdmxrest.getUrl q, 'ECB'
      url.should.be.a 'string'
      url.should.contain 'sdw-wsrest.ecb.europa.eu'
      url.should.contain 'schema'
      url.should.contain 'dataflow/BIS/CBS'

    it 'creates a URL from an availability query and a service objects', ->
      input = {
        flow: 'EXR'
        key: 'A..EUR.SP00.A'
      }
      q = sdmxrest.getAvailabilityQuery input
      s = sdmxrest.getService({url: 'http://ws-entry-point'});
      url = sdmxrest.getUrl q, s
      url.should.be.a 'string'
      url.should.contain 'http://ws-entry-point'
      url.should.contain 'availableconstraint'
      url.should.contain 'EXR/A..EUR.SP00.A'

    it 'creates a URL from an availability and service objects (mode)', ->
      q = {
        flow: 'EXR'
        key: 'A..EUR.SP00.A'
        mode: 'exact'
      }
      s = sdmxrest.getService({url: 'http://ws-entry-point'});
      url = sdmxrest.getUrl q, s
      url.should.be.a 'string'
      url.should.contain 'http://ws-entry-point'
      url.should.contain 'availableconstraint'
      url.should.contain 'EXR/A..EUR.SP00.A'
      url.should.contain 'mode=exact'

    it 'creates a URL from an availability and a service objects (component)', ->
      q = {
        flow: 'EXR'
        key: 'A..EUR.SP00.A'
        component: 'FREQ'
      }
      s = sdmxrest.getService({url: 'http://ws-entry-point'});
      url = sdmxrest.getUrl q, s
      url.should.be.a 'string'
      url.should.contain 'http://ws-entry-point'
      url.should.contain 'availableconstraint'
      url.should.contain 'EXR/A..EUR.SP00.A'
      url.should.contain 'FREQ'

    it 'creates a URL from an availability and a service objects (references)', ->
      q = {
        flow: 'EXR'
        key: 'A..EUR.SP00.A'
        references: 'all'
      }
      s = sdmxrest.getService({url: 'http://ws-entry-point'});
      url = sdmxrest.getUrl q, s
      url.should.be.a 'string'
      url.should.contain 'http://ws-entry-point'
      url.should.contain 'availableconstraint'
      url.should.contain 'EXR/A..EUR.SP00.A'
      url.should.contain 'references=all'

    it 'fails if the input is not of the expected type', ->
      test = -> sdmxrest.getUrl undefined, sdmxrest.getService 'ECB'
      should.Throw(test, Error, 'Not a valid query')

      test = -> sdmxrest.getUrl {}, sdmxrest.getService 'ECB'
      should.Throw(test, Error, 'Not a valid query')

      query = sdmxrest.getDataQuery {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}
      test = -> sdmxrest.getUrl query, sdmxrest.getService 'TEST'
      should.Throw(test, Error, 'not in the list of predefined services')

      test = -> sdmxrest.getUrl query
      should.Throw(test, Error, 'Not a valid service')

  describe 'when using request()', ->

    it 'offers to execute a request from a query and service objects', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      response =
        sdmxrest.request {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}, 'ECB'
      response.should.eventually.equal 'OK'

    it 'offers to execute a request from an SDMX RESTful query string (known service)', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      response = sdmxrest.request 'http://sdw-wsrest.ecb.europa.eu/service/data/EXR'
      response.should.eventually.equal 'OK'

    it 'offers to execute a request from an SDMX RESTful query string (unknown service)', ->
      query = nock('http://test.org')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      response = sdmxrest.request 'http://test.org/data/EXR'
      response.should.eventually.equal 'OK'

    it 'throws an exception in case of issues with a request', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('TEST') > -1)
        .reply 404
      response = sdmxrest.request {flow: 'TEST'}, 'ECB'
      response.should.be.rejectedWith RangeError

    it 'does not throw an exception for a 404 with updatedAfter', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('ICP') > -1)
        .reply 404
      response = sdmxrest.request \
        {flow: 'ICP', updatedAfter: '2016-01-01T14:54:27Z'}, 'ECB'
      response.should.be.fulfilled
      response.should.not.be.rejected

    it 'throws an exception when the Service URL is invalid', ->
      response = sdmxrest.request {flow: 'ICP'}, {url: 'ws.test'}
      response.should.not.be.fulfilled
      response.should.be.rejected

    it 'adds an accept header to data queries if the service has a default format', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .matchHeader('accept', (h) ->
          h[0].indexOf('application/vnd.sdmx.data+json') > -1)
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      response =
        sdmxrest.request {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}, 'ECB'
      response.should.eventually.equal 'OK'

    it 'adds an accept header to data URLs if the service has a default format', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .matchHeader('accept', (h) ->
          h[0].indexOf('application/vnd.sdmx.data+json') > -1)
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      url = 'http://sdw-wsrest.ecb.europa.eu/service/data/EXR/A..EUR.SP00.A'
      response = sdmxrest.request url
      response.should.eventually.equal 'OK'

    it 'does not overwrite the accept header passed by the client', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .matchHeader('accept', (h) ->
          h[0].indexOf('application/xml') > -1)
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      opts =
        headers:
          accept: 'application/xml'
      response =
        sdmxrest.request {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}, 'ECB', opts
      response.should.eventually.equal 'OK'

    it 'does not add an accept header to metadata URLs even if the service has a default format', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .matchHeader('accept', (h) -> h[0] is '*/*')
        .get((uri) -> uri.indexOf('CL_FREQ') > -1)
        .reply 200, 'OK'
      url = 'http://sdw-wsrest.ecb.europa.eu/service/codelist/ECB/CL_FREQ'
      response = sdmxrest.request url
      response.should.eventually.equal 'OK'

    it 'does not add an accept header to data queries if the service does not have a default format', ->
      query = nock('http://stats.oecd.org')
        .matchHeader('accept', (h) -> h[0] is '*/*')
        .get((uri) -> uri.indexOf('EO') > -1)
        .reply 200, 'OK'
      response =
        sdmxrest.request {flow: 'EO'}, 'OECD'
      response.should.eventually.equal 'OK'

    it 'adds a default user agent to queries', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .matchHeader('user-agent', (h) ->
          h[0] is 'sdmx-rest4js (https://github.com/sosna/sdmx-rest4js)')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      response =
        sdmxrest.request {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}, 'ECB'
      response.should.eventually.equal 'OK'

    it 'does not overwrite the user agent passed by the client', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .matchHeader('user-agent', (h) -> h[0] is 'test')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      opts =
        headers:
          'user-agent': 'test'
      response =
        sdmxrest.request {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}, 'ECB', opts
      response.should.eventually.equal 'OK'

    it 'adds a default accept-encoding header to queries', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .matchHeader('accept-encoding', (h) -> h[0] is 'gzip,deflate')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      response =
        sdmxrest.request {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}, 'ECB'
      response.should.eventually.equal 'OK'

    it 'allows disabling content compression', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .matchHeader('accept-encoding', (h) -> h is undefined)
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      opts =
        compress: false
      response =
        sdmxrest.request {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}, 'ECB', opts
      response.should.eventually.equal 'OK'

  describe 'when using request2()', ->
    it 'offers a way to retrieve response headers', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK', {'X-My-Headers': 'My Header value'}
      response =
        sdmxrest.request2 {flow: 'EXR', key: 'A.CHF.EUR.SP00.A'}, 'ECB'
      response.should.eventually.have.property('status').that.equals 200
      response.should.eventually.have.property('headers').that.is.an 'object'
      response.should.eventually.respondTo 'text'

  describe 'when using checkStatus()', ->
    it 'throws an errir in case there is no response', ->

    it 'throws an error in case there is an issue with the response', ->
      request = sdmxrest.getDataQuery({flow: 'TEST'})
      test = -> sdmxrest.checkStatus(request, undefined)
      should.Throw(test, ReferenceError, 'Not a valid response')

    it 'accept codes in the 300 range', ->
      query = nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('TEST') > -1)
        .reply 306, 'Redirected'
      request = sdmxrest.getDataQuery({flow: 'TEST'})
      sdmxrest.request2(request, 'ECB').then((response) ->
        test = -> sdmxrest.checkStatus(request, response)
        should.not.throw(test, RangeError, 'Request failed with error code 306')
      )

    it 'accept code 100', ->
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('TEST') > -1)
        .reply 100, 'Continue'
      request = sdmxrest.getDataQuery({flow: 'TEST'})
      sdmxrest.request2(request, 'ECB').then((response) ->
        test = -> sdmxrest.checkStatus(request, response)
        should.not.throw(test, RangeError, 'Request failed with error code 100')
      )

  describe 'when using checkMediaType()', ->
    it 'accepts SDMX data formats', ->
      fmt = 'application/vnd.sdmx.data+json;version=1.0.0'
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK', {'Content-Type': fmt}
      sdmxrest.request2({flow: 'EXR', key: 'A.CHF.EUR.SP00.A'}, 'ECB').then((response) ->
        test = -> sdmxrest.checkMediaType(fmt, response)
        should.not.throw(test, RangeError, 'Not an SDMX format')
      )

    it 'accepts SDMX metadata formats', ->
      fmt = 'application/vnd.sdmx.structure+xml;version=2.1'
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('codelist') > -1)
        .reply 200, 'OK', {'Content-Type': fmt}
      sdmxrest.request2({resource: 'codelist'}, 'ECB').then((response) ->
        test = -> sdmxrest.checkMediaType(fmt, response)
        should.not.throw(test, RangeError, 'Not an SDMX format')
      )

    it 'accepts generic formats', ->
      fmt = 'application/xml'
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('codelist') > -1)
        .reply 200, 'OK', {'Content-Type': fmt}
      sdmxrest.request2({resource: 'codelist'}, 'ECB').then((response) ->
        test = -> sdmxrest.checkMediaType(fmt, response)
        should.not.throw(test, RangeError, 'Not an SDMX format')
      )

    it 'throws an error in case the format is not an SDMX one', ->
      fmt = 'application/vnd.test.data+json'
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK', {'Content-Type': fmt}
      sdmxrest.request2({flow: 'EXR'}, 'ECB').then((response) ->
        test = -> sdmxrest.checkMediaType(fmt, response)
        should.Throw(test, RangeError, 'Not an SDMX format: ' + fmt))

    it 'throws an error in case no format is specified', ->
      fmt = 'application/xml'
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK'
      sdmxrest.request2({flow: 'EXR'}, 'ECB').then((response) ->
        test = -> sdmxrest.checkMediaType(fmt, response)
        should.Throw(test, RangeError, 'Not an SDMX format: null'))

    it 'throws an error in case the format is not the requested one', ->
      fmt = 'application/vnd.sdmx.data+json;version=1.0.0'
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK', {'Content-Type': 'application/xml'}
      opts =
        headers:
          accept: fmt
      sdmxrest.request2({flow: 'EXR'}, 'ECB', opts).then((response) ->
        test = -> sdmxrest.checkMediaType(fmt, response)
        should.Throw(test, RangeError, 'Wrong format: requested ' + fmt + ' but got application/xml'))

    it 'Does not throw an error in case the received format is the requested one', ->
      fmt = 'application/vnd.sdmx.data+json;version=1.0.0'
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK', {'Content-Type': fmt}
      opts =
        headers:
          accept: fmt
      sdmxrest.request2({flow: 'EXR'}, 'ECB', opts).then((response) ->
        test = -> sdmxrest.checkMediaType(fmt, response)
        should.not.Throw(test))

    it 'Does not throw an error in case the only difference is the space character', ->
      fmt1 = 'application/vnd.sdmx.genericdata+xml;version=2.1'
      fmt2 = 'application/vnd.sdmx.genericdata+xml; version=2.1'
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK', {'Content-Type': fmt2}
      opts =
        headers:
          accept: fmt1
      sdmxrest.request2({flow: 'EXR'}, 'ECB', opts).then((response) ->
        test = -> sdmxrest.checkMediaType(fmt1, response)
        should.not.Throw(test))

    it 'Does not throw an error in case the received format is one of the requested ones', ->
      fmt = 'application/vnd.sdmx.data+json;version=1.0.0, application/json;q=0.9, text/csv;q=0.5, */*;q=0.4'
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK', {'Content-Type': 'text/csv'}
      opts =
        headers:
          accept: fmt
      sdmxrest.request2({flow: 'EXR'}, 'ECB', opts).then((response) ->
        test = -> sdmxrest.checkMediaType(fmt, response)
        should.not.Throw(test))

    it 'Throws an error in case the received format is not one of the requested ones', ->
      fmt = 'application/vnd.sdmx.data+json;version=1.0.0, application/json;q=0.9, text/csv;q=0.5, */*;q=0.4'
      nock('http://sdw-wsrest.ecb.europa.eu')
        .get((uri) -> uri.indexOf('EXR') > -1)
        .reply 200, 'OK', {'Content-Type': 'application/xml'}
      opts =
        headers:
          accept: fmt
      sdmxrest.request2({flow: 'EXR'}, 'ECB', opts).then((response) ->
        test = -> sdmxrest.checkMediaType(fmt, response)
        should.Throw(test, RangeError))
