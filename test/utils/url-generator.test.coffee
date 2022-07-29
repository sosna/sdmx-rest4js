should = require('chai').should()

{Service} = require '../../src/service/service'
{ApiVersion} = require '../../src/utils/api-version'
{DataQuery} = require '../../src/data/data-query'
{MetadataQuery} = require '../../src/metadata/metadata-query'
{AvailabilityQuery} = require '../../src/avail/availability-query'
{SchemaQuery} = require '../../src/schema/schema-query'
{UrlGenerator} = require '../../src/utils/url-generator'

describe 'URL Generator (generic)', ->

  it 'throws an exception if no query is supplied', ->
    test = -> new UrlGenerator().getUrl()
    should.Throw(test, Error,
      'A valid query must be supplied')

  it 'throws an exception if the input is not a data or a metadata query', ->
    service = Service.from({
      url: 'http://test.com'
      api: ApiVersion.v2_0_0
    })
    test = -> new UrlGenerator().getUrl({test: 'Test'}, service)
    should.Throw(test, TypeError, 'not a valid query')

  it 'throws an exception if no service is supplied', ->
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB'
      item: 'A'
    })
    test = -> new UrlGenerator().getUrl query
    should.Throw(test, Error, 'not a valid service')

  it 'throws an exception if a service without a URL is supplied', ->
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB'
      item: 'A'
    })
    test = -> new UrlGenerator().getUrl query, {id: 'test'}
    should.Throw(test, ReferenceError, 'not a valid service')
