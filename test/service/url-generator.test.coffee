should = require('chai').should()
assert = require('chai').assert

{Service} = require '../../src/service/service.coffee'
{ServiceType} = require '../../src/service/service-type.coffee'
{DataQuery} = require '../../src/data/data-query.coffee'
{MetadataQuery} = require '../../src/metadata/metadata-query.coffee'
{UrlGenerator} = require '../../src/utils/url-generator.coffee'

describe 'URL Generator', ->

  it 'should generate a URL for a metadata query', ->
    expected = "http://sdw-wsrest.ecb.europa.eu/service/codelist/ECB/CL_FREQ/\
    latest?detail=full&references=none"
    query =
      MetadataQuery.from({resource: 'codelist', id: 'CL_FREQ', agency: 'ECB'})
    service = Service.ECB
    gen = new UrlGenerator()
    url = gen.getUrl(query, service)
    url.should.equal expected

  it 'should allow item queries only for API version 1.1.0 and above', ->
    expected = "http://test.com/codelist/ECB/CL_FREQ/latest/A\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB'
      item: 'A'
    })
    service = Service.from({
      url: 'http://test.com'
      api: ServiceType.SDMX_REST_v1_1_0
    })
    gen = new UrlGenerator()
    url = gen.getUrl(query, service)
    url.should.equal expected

  it 'should default to API version 1.1.0 for metadata queries', ->
    expected = "http://test.com/codelist/ECB/CL_FREQ/latest/A\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB'
      item: 'A'
    })
    service = Service.from({
      url: 'http://test.com/'
    })
    gen = new UrlGenerator()
    url = gen.getUrl(query, service)
    url.should.equal expected

  it 'should generate a URL for a full data query', ->
    expected = "http://test.com/data/EXR/A..EUR.SP00.A/ECB?\
    dimensionAtObservation=CURRENCY&detail=nodata&includeHistory=true\
    &startPeriod=2010&endPeriod=2015&updatedAfter=2016-03-01T00:00:00Z\
    &firstNObservations=1&lastNObservations=1"
    query = DataQuery.from({
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
      provider: 'ECB'
      obsDimension: 'CURRENCY'
      detail: 'nodata'
      history: true
      start: '2010'
      end: '2015'
      updatedAfter: '2016-03-01T00:00:00Z'
      firstNObs: 1
      lastNObs: 1
    })
    service = Service.from({
      url: 'http://test.com'
      api: ServiceType.SDMX_REST_v1_1_0
    })
    gen = new UrlGenerator()
    url = gen.getUrl(query, service)
    url.should.equal expected

  it 'should generate a URL for a partial data query', ->
    expected = "http://test.com/data/EXR/A..EUR.SP00.A/all?\
    dimensionAtObservation=TIME_PERIOD&detail=full&includeHistory=false"
    query = DataQuery.from({flow: 'EXR', key: 'A..EUR.SP00.A'})
    service = Service.from({
      url: 'http://test.com'
      api: ServiceType.SDMX_REST_v1_1_0
    })
    gen = new UrlGenerator()
    url = gen.getUrl(query, service)
    url.should.equal expected

  it 'should allow history only for API version 1.1.0 and above', ->
    expected = "http://test.com/data/EXR/A..EUR.SP00.A/ECB?\
    dimensionAtObservation=CURRENCY&detail=nodata\
    &startPeriod=2010&endPeriod=2015&updatedAfter=2016-03-01T00:00:00Z\
    &firstNObservations=1&lastNObservations=1"
    query = DataQuery.from({
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
      provider: 'ECB'
      obsDimension: 'CURRENCY'
      detail: 'nodata'
      history: true
      start: '2010'
      end: '2015'
      updatedAfter: '2016-03-01T00:00:00Z'
      firstNObs: 1
      lastNObs: 1
    })
    service = Service.from({
      url: 'http://test.com'
      api: ServiceType.SDMX_REST_v1_0_2
    })
    gen = new UrlGenerator()
    url = gen.getUrl(query, service)
    url.should.equal expected

  it 'should default to API version 1.1.0 for data queries', ->
    expected = "http://test.com/data/EXR/A..EUR.SP00.A/ECB?\
    dimensionAtObservation=CURRENCY&detail=nodata&includeHistory=true\
    &startPeriod=2010&endPeriod=2015&updatedAfter=2016-03-01T00:00:00Z\
    &firstNObservations=1&lastNObservations=1"
    query = DataQuery.from({
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
      provider: 'ECB'
      obsDimension: 'CURRENCY'
      detail: 'nodata'
      history: true
      start: '2010'
      end: '2015'
      updatedAfter: '2016-03-01T00:00:00Z'
      firstNObs: 1
      lastNObs: 1
    })
    service = Service.from({
      url: 'http://test.com'
    })
    gen = new UrlGenerator()
    url = gen.getUrl(query, service)
    url.should.equal expected

  it 'should not allow an empty query', ->
    try
      gen = new UrlGenerator()
      gen.getUrl()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'not a valid SDMX data or metadata query'

  it 'should not allow an empty service', ->
    try
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ'
        agency: 'ECB'
        item: 'A'
      })
      gen = new UrlGenerator()
      gen.getUrl query
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'not a valid service'

  it 'should accept either a data or a metadata query', ->
    try
      gen = new UrlGenerator()
      gen.getUrl({test: 'Test'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'not a valid SDMX data or metadata query'
