should = require('chai').should()

{Service} = require '../../src/service/service'
{ApiVersion} = require '../../src/utils/api-version'
{DataQuery} = require '../../src/data/data-query'
{MetadataQuery} = require '../../src/metadata/metadata-query'
{AvailabilityQuery} = require '../../src/avail/availability-query'
{SchemaQuery} = require '../../src/schema/schema-query'
{UrlGenerator} = require '../../src/utils/url-generator'

describe 'URL Generator for schema queries', ->

  it 'generates a URL for a schema query', ->
    expected = "http://sdw-wsrest.ecb.europa.eu/service/schema/dataflow\
    /ECB/EXR/1.0?explicitMeasure=false"
    query = SchemaQuery.from({context: 'dataflow', id: 'EXR', agency: 'ECB', version: '1.0'})
    service = Service.ECB
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'generates a URL for a schema query (with dimensionAtObservation)', ->
    expected = "http://sdw-wsrest.ecb.europa.eu/service/schema/dataflow\
    /ECB/EXR/latest?explicitMeasure=false&dimensionAtObservation=TEST"
    query = SchemaQuery.from(
      {context: 'dataflow', id: 'EXR', agency: 'ECB', obsDimension: 'TEST'})
    service = Service.ECB
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'offers to skip default values for schema', ->
    expected = "http://test.com/schema/dataflow/ECB/EXR"
    query = SchemaQuery.from({context: 'dataflow', id: 'EXR', agency: 'ECB'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (version)', ->
    expected = "http://test.com/schema/dataflow/ECB/EXR/1.1"
    query = SchemaQuery.from(
      {context: 'dataflow', id: 'EXR', agency: 'ECB', version: '1.1'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (explicit)', ->
    expected = "http://test.com/schema/dataflow/ECB/EXR?explicitMeasure=true"
    query = SchemaQuery.from(
      {context: 'dataflow', id: 'EXR', agency: 'ECB', explicit: true})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (obsDimension)', ->
    expected = 
      "http://test.com/schema/dataflow/ECB/EXR?dimensionAtObservation=TEST"
    query = SchemaQuery.from(
      {context: 'dataflow', id: 'EXR', agency: 'ECB', obsDimension: 'TEST'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (query params)', ->
    expected = "http://test.com/schema/dataflow/ECB/EXR?explicitMeasure=true\
    &dimensionAtObservation=TEST"
    query = SchemaQuery.from(
      {context: 'dataflow', id: 'EXR', agency: 'ECB', explicit: true,
      obsDimension: 'TEST'})
    service = Service.from({url: 'http://test.com',  api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'supports metadataprovisionagreement since v2.0.0', ->
    expected = "http://test.com/schema/metadataprovisionagreement/ECB/EXR?\
    dimensionAtObservation=TEST"
    query = SchemaQuery.from(
      {context: 'metadataprovisionagreement', id: 'EXR', agency: 'ECB',
      obsDimension: 'TEST'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'does not support metadataprovisionagreement before v2.0.0', ->
    query = SchemaQuery.from(
      {context: 'metadataprovisionagreement', id: 'EXR', agency: 'ECB',
      obsDimension: 'TEST'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'metadataprovisionagreement not allowed in v1.5.0')

  it 'does not support explicitMeasure starting with v2.0.0', ->
    query = SchemaQuery.from(
      {context: 'provisionagreement', id: 'EXR', agency: 'ECB',
      obsDimension: 'TEST', explicit: true})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'explicit parameter not allowed in v2.0.0')

  it 'does no longer use default explicitMeasure starting with v2.0.0', ->
    expected = "http://test.com/schema/dataflow/ECB/EXR/1.0.0"
    query = SchemaQuery.from(
      {context: 'dataflow', id: 'EXR', agency: 'ECB', version: '1.0.0'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'does not support semver before v2.0.0', ->
    query = SchemaQuery.from(
      {context: 'dataflow', id: 'EXR', agency: 'ECB', version: '~'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'Semantic versioning not allowed in v1.5.0')

    query = SchemaQuery.from(
      {context: 'dataflow', id: 'EXR', agency: 'ECB', version: '1.2+.42'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'Semantic versioning not allowed in v1.5.0')

  it 'rewrites version keywords since v2.0.0', ->
    expected = "http://test.com/schema/dataflow/ECB/EXR/~?\
    dimensionAtObservation=TEST"
    query = SchemaQuery.from(
      {context: 'dataflow', id: 'EXR', agency: 'ECB', version: 'latest',
      obsDimension: 'TEST'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected
