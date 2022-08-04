should = require('chai').should()

{Service} = require '../../src/service/service'
{ApiVersion} = require '../../src/utils/api-version'
{DataQuery2} = require '../../src/data/data-query2'
{UrlGenerator} = require '../../src/utils/url-generator'

describe 'URL Generator for data queries', ->

  it 'generates a URL for a full data query', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/A..EUR.SP00.A\
    ?c[OBS_CONF]=F&dimensionAtObservation=CURRENCY\
    &attributes=dataset,series&measures=none\
    &includeHistory=true\
    &updatedAfter=2016-03-01T00:00:00Z\
    &firstNObservations=1&lastNObservations=2"
    query = DataQuery2.from({
      context: 'dataflow=*:EXR(*)'
      key: 'A..EUR.SP00.A'
      filters: 'OBS_CONF=F'
      updatedAfter: '2016-03-01T00:00:00Z'
      firstNObs: 1
      lastNObs: 2
      obsDimension: 'CURRENCY'
      attributes: 'dataset,series'
      measures: 'none'
      history: true
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'generates a URL for a partial data query', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/*?\
    attributes=dsd&measures=all&includeHistory=false"
    query = DataQuery2.from({context: 'dataflow=*:EXR(*)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'offers to skip all default values', ->
    expected = "http://test.com/data"
    query = DataQuery2.from null
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (context)', ->
    expected = "http://test.com/data/dataflow"
    query = DataQuery2.from({context: 'dataflow=*:*(*)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (agency)', ->
    expected = "http://test.com/data/*/BIS"
    query = DataQuery2.from({context: '*=BIS:*(*)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected
  
  it 'offers to skip default values (artefact)', ->
    expected = "http://test.com/data/*/*/EXR"
    query = DataQuery2.from({context: '*=*:EXR(*)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (version)', ->
    expected = "http://test.com/data/*/*/*/~"
    query = DataQuery2.from({context: '*=*:*(~)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (key)', ->
    expected = "http://test.com/data/*/*/*/*/A.CHF"
    query = DataQuery2.from({key: 'A.CHF'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (filters)', ->
    expected = "http://test.com/data?c[REF_AREA]=UY,AR"
    query = DataQuery2.from({filters: 'REF_AREA=UY,AR'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (updatedAfter)', ->
    expected = "http://test.com/data/dataflow/*/EXR?updatedAfter=2016-03-01T00:00:00Z"
    query = DataQuery2.from({
      context: 'dataflow=*:EXR(*)'
      updatedAfter: '2016-03-01T00:00:00Z'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (firstNObs)', ->
    expected = "http://test.com/data/dataflow/*/EXR?firstNObservations=1"
    query = DataQuery2.from({context: 'dataflow=*:EXR(*)', firstNObs: 1})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (lastNObs)', ->
    expected = "http://test.com/data/dataflow/*/EXR?lastNObservations=2"
    query = DataQuery2.from({context: 'dataflow=*:EXR(*)', lastNObs: 2})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (obsDim)', ->
    expected = "http://test.com/data/dataflow/*/EXR?dimensionAtObservation=CURR"
    query = DataQuery2.from({context: 'dataflow=*:EXR(*)', obsDimension: 'CURR'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (attributes)', ->
    expected = "http://test.com/data/dataflow/*/EXR?attributes=msd"
    query = DataQuery2.from({context: 'dataflow=*:EXR(*)', attributes: 'msd'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (measures)', ->
    expected = "http://test.com/data/dataflow/*/EXR?measures=none"
    query = DataQuery2.from({context: 'dataflow=*:EXR(*)', measures: 'none'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (history)', ->
    expected = "http://test.com/data/dataflow/*/EXR?includeHistory=true"
    query = DataQuery2.from({context: 'dataflow=*:EXR(*)', history: true})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (various)', ->
    expected = "http://test.com/data/dataflow/*/EXR/*/A..EUR.SP00.A?\
    updatedAfter=2016-03-01T00:00:00Z\
    &attributes=msd&dimensionAtObservation=CURRENCY"
    query = DataQuery2.from({
      context: 'dataflow=*:EXR(*)'
      key: 'A..EUR.SP00.A'
      attributes: 'msd'
      obsDimension: 'CURRENCY'
      updatedAfter: '2016-03-01T00:00:00Z'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected
