should = require('chai').should()
assert = require('chai').assert

{Service} = require '../../src/service/service'
{ApiVersion} = require '../../src/utils/api-version'
{DataQuery} = require '../../src/data/data-query'
{MetadataQuery} = require '../../src/metadata/metadata-query'
{UrlGenerator} = require '../../src/utils/url-generator'

describe 'URL Generator', ->

  describe 'for metadata queries', ->

    it 'generates a URL for a metadata query', ->
      expected = "http://sdw-wsrest.ecb.europa.eu/service/codelist/ECB/CL_FREQ/\
      latest?detail=full&references=none"
      query =
        MetadataQuery.from({resource: 'codelist', id: 'CL_FREQ', agency: 'ECB'})
      service = Service.ECB
      gen = new UrlGenerator()
      url = gen.getUrl(query, service)
      url.should.equal expected

    it 'supports item queries but only for API version 1.1.0 and above', ->
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
        api: ApiVersion.v1_1_0
      })
      gen = new UrlGenerator()
      url = gen.getUrl(query, service)
      url.should.equal expected

    it 'defaults to API version 1.1.0', ->
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

  describe 'for data queries', ->

    it 'generates a URL for a full data query', ->
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
        api: ApiVersion.v1_1_0
      })
      gen = new UrlGenerator()
      url = gen.getUrl(query, service)
      url.should.equal expected

    it 'generates a URL for a partial data query', ->
      expected = "http://test.com/data/EXR/A..EUR.SP00.A/all?\
      dimensionAtObservation=TIME_PERIOD&detail=full&includeHistory=false"
      query = DataQuery.from({flow: 'EXR', key: 'A..EUR.SP00.A'})
      service = Service.from({
        url: 'http://test.com'
        api: ApiVersion.v1_1_0
      })
      gen = new UrlGenerator()
      url = gen.getUrl(query, service)
      url.should.equal expected

    it 'supports history but only for API version 1.1.0 and above', ->
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
        api: ApiVersion.v1_0_2
      })
      gen = new UrlGenerator()
      url = gen.getUrl(query, service)
      url.should.equal expected

    it 'defaults to API version 1.1.0', ->
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

  it 'throws an exception if no query is supplied', ->
    try
      gen = new UrlGenerator()
      gen.getUrl()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'not a valid SDMX data or metadata query'

  it 'throws an exception if no service is supplied', ->
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

  it 'throws an exception if the input is not a data or a metadata query', ->
    try
      gen = new UrlGenerator()
      gen.getUrl({test: 'Test'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'not a valid SDMX data or metadata query'
