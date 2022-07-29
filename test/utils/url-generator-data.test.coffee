should = require('chai').should()

{Service} = require '../../src/service/service'
{ApiVersion} = require '../../src/utils/api-version'
{DataQuery} = require '../../src/data/data-query'
{UrlGenerator} = require '../../src/utils/url-generator'

describe 'URL Generator for data queries', ->

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
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'generates a URL for a full data query (2.0.0)', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/A..EUR.SP00.A\
    ?dimensionAtObservation=CURRENCY\
    &attributes=dataset,series&measures=none\
    &includeHistory=true\
    &updatedAfter=2016-03-01T00:00:00Z\
    &firstNObservations=1&lastNObservations=1"
    query = DataQuery.from({
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
      obsDimension: 'CURRENCY'
      detail: 'nodata'
      history: true
      updatedAfter: '2016-03-01T00:00:00Z'
      firstNObs: 1
      lastNObs: 1
    })
    service = Service.from({
      url: 'http://test.com'
      api: ApiVersion.v2_0_0
    })
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'generates a URL for a partial data query', ->
    expected = "http://test.com/data/EXR/A..EUR.SP00.A/all?\
    detail=full&includeHistory=false"
    query = DataQuery.from({flow: 'EXR', key: 'A..EUR.SP00.A'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_1_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'generates a URL for a partial data query (2.0.0)', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/A..EUR.SP00.A?\
    attributes=dsd&measures=all&includeHistory=false"
    query = DataQuery.from({flow: 'EXR', key: 'A..EUR.SP00.A'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
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
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_2})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'defaults to latest API', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/A..EUR.SP00.A?\
    dimensionAtObservation=CURRENCY&attributes=dataset,series&measures=none\
    &includeHistory=true&updatedAfter=2016-03-01T00:00:00Z\
    &firstNObservations=1&lastNObservations=1"
    query = DataQuery.from({
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
      obsDimension: 'CURRENCY'
      detail: 'nodata'
      history: true
      updatedAfter: '2016-03-01T00:00:00Z'
      firstNObs: 1
      lastNObs: 1
    })
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'offers to skip default values for data', ->
    expected = "http://test.com/data/EXR"
    query = DataQuery.from({flow: 'EXR'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values for data (v2.0.0)', ->
    expected = "http://test.com/data/dataflow/*/EXR"
    query = DataQuery.from({flow: 'EXR'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (provider)', ->
    expected = "http://test.com/data/EXR/all/ECB"
    query = DataQuery.from({flow: 'EXR', provider: 'ECB'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (start)', ->
    expected = "http://test.com/data/EXR?startPeriod=2010"
    query = DataQuery.from({flow: 'EXR', start: '2010'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (end)', ->
    expected = "http://test.com/data/EXR?endPeriod=2010"
    query = DataQuery.from({flow: 'EXR', end: '2010'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (updatedAfter)', ->
    expected = "http://test.com/data/EXR?updatedAfter=2016-03-01T00:00:00Z"
    query = DataQuery.from({
      flow: 'EXR'
      updatedAfter: '2016-03-01T00:00:00Z'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (updatedAfter, 2.0.0)', ->
    expected = "http://test.com/data/dataflow/*/EXR?updatedAfter=2016-03-01T00:00:00Z"
    query = DataQuery.from({
      flow: 'EXR'
      updatedAfter: '2016-03-01T00:00:00Z'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (firstNObs)', ->
    expected = "http://test.com/data/EXR?firstNObservations=1"
    query = DataQuery.from({flow: 'EXR', firstNObs: 1})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (firstNObs, 2.0.0)', ->
    expected = "http://test.com/data/dataflow/*/EXR?firstNObservations=1"
    query = DataQuery.from({flow: 'EXR', firstNObs: 1})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (lastNObs)', ->
    expected = "http://test.com/data/EXR?lastNObservations=2"
    query = DataQuery.from({flow: 'EXR', lastNObs: 2})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (lastNObs, 2.0.0)', ->
    expected = "http://test.com/data/dataflow/*/EXR?lastNObservations=2"
    query = DataQuery.from({flow: 'EXR', lastNObs: 2})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (detail)', ->
    expected = "http://test.com/data/EXR?detail=dataonly"
    query = DataQuery.from({flow: 'EXR', detail: 'dataonly'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (detail, 2.0.0)', ->
    expected = "http://test.com/data/dataflow/*/EXR?attributes=none&measures=all"
    query = DataQuery.from({flow: 'EXR', detail: 'dataonly'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (history)', ->
    expected = "http://test.com/data/EXR?includeHistory=true"
    query = DataQuery.from({flow: 'EXR', history: true})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (history, 2.0.0)', ->
    expected = "http://test.com/data/dataflow/*/EXR?includeHistory=true"
    query = DataQuery.from({flow: 'EXR', history: true})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (obsDim)', ->
    expected = "http://test.com/data/EXR?dimensionAtObservation=CURR"
    query = DataQuery.from({flow: 'EXR', obsDimension: 'CURR'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (obsDim, 2.0.0)', ->
    expected = "http://test.com/data/dataflow/*/EXR?dimensionAtObservation=CURR"
    query = DataQuery.from({flow: 'EXR', obsDimension: 'CURR'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (various)', ->
    expected = "http://test.com/data/EXR/A..EUR.SP00.A?\
    updatedAfter=2016-03-01T00:00:00Z\
    &startPeriod=2010&dimensionAtObservation=CURRENCY"
    query = DataQuery.from({
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
      obsDimension: 'CURRENCY'
      start: '2010'
      updatedAfter: '2016-03-01T00:00:00Z'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (various, 2.0.0)', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/A..EUR.SP00.A?\
    updatedAfter=2016-03-01T00:00:00Z\
    &dimensionAtObservation=CURRENCY"
    query = DataQuery.from({
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
      obsDimension: 'CURRENCY'
      updatedAfter: '2016-03-01T00:00:00Z'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'supports multiple providers for API version 1.3.0 and until 2.0.0', ->
    expected = "http://test.com/data/EXR/A..EUR.SP00.A/SDMX,ECB+BIS?\
    updatedAfter=2016-03-01T00:00:00Z\
    &startPeriod=2010&dimensionAtObservation=CURRENCY"
    query = DataQuery.from({
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
      obsDimension: 'CURRENCY'
      start: '2010'
      updatedAfter: '2016-03-01T00:00:00Z'
      provider: ['SDMX,ECB', 'BIS']
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'does not support providers before API version 1.3.0', ->
    query = DataQuery.from({flow: 'EXR', provider: 'SDMX,ECB+BIS'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'Multiple providers not allowed in v1.2.0')

  it 'throws an error when using provider with 2.0.0', ->
    query = DataQuery.from({flow: 'EXR', provider: 'ECB'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service
    should.Throw(test, Error, 'provider not allowed in v2.0.0')

    query = DataQuery.from({flow: 'EXR', provider: 'ECB'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service, true
    should.Throw(test, Error, 'provider not allowed in v2.0.0')

  it 'throws an error when using start with 2.0.0', ->
    query = DataQuery.from({flow: 'EXR', start: '2007'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service
    should.Throw(test, Error, 'start not allowed in v2.0.0')

    query = DataQuery.from({flow: 'EXR', start: '2007'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service, true
    should.Throw(test, Error, 'start not allowed in v2.0.0')

  it 'throws an error when using end with 2.0.0', ->
    query = DataQuery.from({flow: 'EXR', end: '2007'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service
    should.Throw(test, Error, 'end not allowed in v2.0.0')

    query = DataQuery.from({flow: 'EXR', end: '2007'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl query, service, true
    should.Throw(test, Error, 'end not allowed in v2.0.0')

  it 'translates details=full with 2.0.0', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/*?\
    attributes=dsd&measures=all&includeHistory=false"
    query = DataQuery.from({
      flow: 'EXR'
      detail: 'full'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/data/dataflow/*/EXR"
    query = DataQuery.from({
      flow: 'EXR'
      detail: 'full'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'translates details=dataonly with 2.0.0', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/*?\
    attributes=none&measures=all&includeHistory=false"
    query = DataQuery.from({
      flow: 'EXR'
      detail: 'dataonly'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/data/dataflow/*/EXR?\
    attributes=none&measures=all"
    query = DataQuery.from({
      flow: 'EXR'
      detail: 'dataonly'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'translates details=serieskeysonly with 2.0.0', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/*?\
    attributes=none&measures=none&includeHistory=false"
    query = DataQuery.from({
      flow: 'EXR'
      detail: 'serieskeysonly'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/data/dataflow/*/EXR?\
    attributes=none&measures=none"
    query = DataQuery.from({
      flow: 'EXR'
      detail: 'serieskeysonly'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'translates details=nodata with 2.0.0', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/*?\
    attributes=dataset,series&measures=none&includeHistory=false"
    query = DataQuery.from({
      flow: 'EXR'
      detail: 'nodata'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/data/dataflow/*/EXR?\
    attributes=dataset,series&measures=none"
    query = DataQuery.from({
      flow: 'EXR'
      detail: 'nodata'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'translates 1-part dataflow in the correct 2.0.0 context', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/*?\
    attributes=dsd&measures=all&includeHistory=false"
    query = DataQuery.from({
      flow: 'EXR'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/data/dataflow/*/EXR"
    query = DataQuery.from({
      flow: 'EXR'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'translates 2-parts dataflow in the correct 2.0.0 context', ->
    expected = "http://test.com/data/dataflow/ECB/EXR/*/*?\
    attributes=dsd&measures=all&includeHistory=false"
    query = DataQuery.from({
      flow: 'ECB,EXR'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/data/dataflow/ECB/EXR"
    query = DataQuery.from({
      flow: 'ECB,EXR'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'translates 3-parts dataflow in the correct 2.0.0 context', ->
    expected = "http://test.com/data/dataflow/ECB/EXR/1.42/*?\
    attributes=dsd&measures=all&includeHistory=false"
    query = DataQuery.from({
      flow: 'ECB,EXR,1.42'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/data/dataflow/ECB/EXR/1.42"
    query = DataQuery.from({
      flow: 'ECB,EXR,1.42'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'rejects keys containing dimensions separated with + (2.0.0)', ->
    query = DataQuery.from({
      flow: 'ECB,EXR,1.42'
      key: 'A+M.CHF'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, '+ not allowed in key in v2.0.0')

    query = DataQuery.from({
      flow: 'ECB,EXR,1.42'
      key: 'A+M.CHF'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl(query, service, true)
    should.Throw(test, Error, '+ not allowed in key in v2.0.0')
