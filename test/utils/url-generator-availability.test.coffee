should = require('chai').should()

{Service} = require '../../src/service/service'
{ApiVersion} = require '../../src/utils/api-version'
{AvailabilityQuery} = require '../../src/avail/availability-query'
{UrlGenerator} = require '../../src/utils/url-generator'

describe 'URL Generator for availability queries', ->

  it 'generates a URL for a full availability query', ->
    expected = 'http://test.com/availableconstraint/EXR/A..EUR.SP00.A/ECB/FREQ?\
    mode=available&references=none\
    &startPeriod=2010&endPeriod=2015&updatedAfter=2016-03-01T00:00:00Z'
    query = AvailabilityQuery.from({
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
      provider: 'ECB'
      component: 'FREQ'
      start: '2010'
      end: '2015'
      updatedAfter: '2016-03-01T00:00:00Z'
      mode: 'available'
      references: 'none'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'generates a URL for a full availability query (2.0.0)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR/*/A..EUR.SP00.A/FREQ?\
    mode=available&references=none\
    &updatedAfter=2016-03-01T00:00:00Z'
    query = AvailabilityQuery.from({
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
      component: 'FREQ'
      updatedAfter: '2016-03-01T00:00:00Z'
      mode: 'available'
      references: 'none'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'generates a URL for a partial availability query', ->
    expected = 'http://test.com/availableconstraint/EXR/A..EUR.SP00.A/all/all?\
    mode=exact&references=none'
    query = AvailabilityQuery.from({flow: 'EXR', key: 'A..EUR.SP00.A'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'generates a URL for a partial availability query (2.0.0)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR/*/*/*?\
    mode=exact&references=none'
    query = AvailabilityQuery.from({flow: 'EXR'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'supports minimal query if proper query class is used', ->
    expected = 'http://test.com/availableconstraint/EXR/all/all/all?\
    mode=exact&references=none'
    query = AvailabilityQuery.from({flow: 'EXR'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'does not support availability queries before v1.3.0', ->
    query = AvailabilityQuery.from({flow: 'EXR', key: 'A..EUR.SP00.A'})
    service = Service.from({url: 'http://test.com', api: 'v1.2.0'})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'Availability query not supported in v1.2.0')

  it 'offers to skip default values for availability', ->
    expected = 'http://test.com/availableconstraint/EXR'
    query = AvailabilityQuery.from({
      flow: 'EXR'
      mode: 'exact'
      references: 'none'
    })
    service = Service.from({url: 'http://test.com', api: 'v1.5.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values for availability (2.0.0)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR'
    query = AvailabilityQuery.from({
      flow: 'EXR'
      mode: 'exact'
      references: 'none'
    })
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (key, 2.0.0)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR/*/A.CH'
    query = AvailabilityQuery.from({flow: 'EXR', key: 'A.CH'})
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected
  
  it 'offers to skip defaults but adds them when needed (provider)', ->
    expected = 'http://test.com/availableconstraint/EXR/all/ECB'
    query = AvailabilityQuery.from({flow: 'EXR', provider: 'ECB'})
    service = Service.from({url: 'http://test.com', api: 'v1.5.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (component)', ->
    expected = 'http://test.com/availableconstraint/EXR/all/all/FREQ'
    query = AvailabilityQuery.from({flow: 'EXR', component: 'FREQ'})
    service = Service.from({url: 'http://test.com', api: 'v1.5.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (component, 2.0.0)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR/*/*/FREQ'
    query = AvailabilityQuery.from({flow: 'EXR', component: 'FREQ'})
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (mode)', ->
    expected = 'http://test.com/availableconstraint/EXR?mode=available'
    query = AvailabilityQuery.from({flow: 'EXR', mode: 'available'})
    service = Service.from({url: 'http://test.com', api: 'v1.5.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (mode, 2.0.0)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR\
    ?mode=available'
    query = AvailabilityQuery.from({flow: 'EXR', mode: 'available'})
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (refs)', ->
    expected = 'http://test.com/availableconstraint/EXR?references=codelist'
    query = AvailabilityQuery.from({flow: 'EXR', references: 'codelist'})
    service = Service.from({url: 'http://test.com', api: 'v1.5.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (refs, 2.0.0)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR\
    ?references=codelist'
    query = AvailabilityQuery.from({flow: 'EXR', references: 'codelist'})
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (start)', ->
    expected = 'http://test.com/availableconstraint/EXR?startPeriod=2007'
    query = AvailabilityQuery.from({flow: 'EXR', start: '2007'})
    service = Service.from({url: 'http://test.com', api: 'v1.5.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (end)', ->
    expected = 'http://test.com/availableconstraint/EXR?endPeriod=2073'
    query = AvailabilityQuery.from({flow: 'EXR', end: '2073'})
    service = Service.from({url: 'http://test.com', api: 'v1.5.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (start & end)', ->
    expected = 'http://test.com/availableconstraint/EXR?startPeriod=2007&\
    endPeriod=2073'
    query = AvailabilityQuery.from({flow: 'EXR', start: '2007', end: '2073'})
    service = Service.from({url: 'http://test.com', api: 'v1.5.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (upd)', ->
    expected = 'http://test.com/availableconstraint/EXR?\
    updatedAfter=2016-03-01T00:00:00Z'
    query = AvailabilityQuery.from({
      flow: 'EXR'
      updatedAfter: '2016-03-01T00:00:00Z'})
    service = Service.from({url: 'http://test.com', api: 'v1.5.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (upd, 2.0.0)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR?\
    updatedAfter=2016-03-01T00:00:00Z'
    query = AvailabilityQuery.from({
      flow: 'EXR'
      updatedAfter: '2016-03-01T00:00:00Z'})
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (multi, 2.0.0)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR?\
    mode=available&updatedAfter=2016-03-01T00:00:00Z'
    query = AvailabilityQuery.from({
      flow: 'EXR'
      updatedAfter: '2016-03-01T00:00:00Z',
      mode: 'available'
      })
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'throws an error when using provider with 2.0.0', ->
    query = AvailabilityQuery.from({flow: 'EXR', provider: 'ECB'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service
    should.Throw(test, Error, 'provider not allowed in v2.0.0')

    query = AvailabilityQuery.from({flow: 'EXR', provider: 'ECB'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service, true
    should.Throw(test, Error, 'provider not allowed in v2.0.0')

  it 'throws an error when using start with 2.0.0', ->
    query = AvailabilityQuery.from({flow: 'EXR', start: '2007'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service
    should.Throw(test, Error, 'start not allowed in v2.0.0')

    query = AvailabilityQuery.from({flow: 'EXR', start: '2007'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service, true
    should.Throw(test, Error, 'start not allowed in v2.0.0')

  it 'throws an error when using end with 2.0.0', ->
    query = AvailabilityQuery.from({flow: 'EXR', end: '2007'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service
    should.Throw(test, Error, 'end not allowed in v2.0.0')

    query = AvailabilityQuery.from({flow: 'EXR', end: '2007'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service, true
    should.Throw(test, Error, 'end not allowed in v2.0.0')

  it 'rejects keys containing dimensions separated with + (2.0.0)', ->
    query = AvailabilityQuery.from({
      flow: 'ECB,EXR,1.42'
      key: 'A+M.CHF'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, '+ not allowed in key in v2.0.0')

    query = AvailabilityQuery.from({
      flow: 'ECB,EXR,1.42'
      key: 'A+M.CHF'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl(query, service, true)
    should.Throw(test, Error, '+ not allowed in key in v2.0.0')
