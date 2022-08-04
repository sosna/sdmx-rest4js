should = require('chai').should()

{Service} = require '../../src/service/service'
{ApiVersion} = require '../../src/utils/api-version'
{AvailabilityQuery2} = require '../../src/avail/availability-query2'
{UrlGenerator} = require '../../src/utils/url-generator'

describe 'URL Generator for SDMX 3.0 availability queries', ->

  it 'generates a URL for a full availability query', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR/*/A..EUR.SP00.A/FREQ?\
    mode=available&references=none\
    &updatedAfter=2016-03-01T00:00:00Z'
    query = AvailabilityQuery2.from({
      context: 'dataflow=*:EXR(*)'
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
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR/*/*/*?\
    mode=exact&references=none'
    query = AvailabilityQuery2.from({context: 'dataflow=*:EXR(*)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'offers to skip all default values', ->
    expected = 'http://test.com/availableconstraint'
    query = AvailabilityQuery2.from null 
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (context)', ->
    expected = "http://test.com/availableconstraint/dataflow"
    query = AvailabilityQuery2.from({context: 'dataflow=*:*(*)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (agency)', ->
    expected = "http://test.com/availableconstraint/*/BIS"
    query = AvailabilityQuery2.from({context: '*=BIS:*(*)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected
  
  it 'offers to skip default values (artefact)', ->
    expected = "http://test.com/availableconstraint/*/*/EXR"
    query = AvailabilityQuery2.from({context: '*=*:EXR(*)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (version)', ->
    expected = "http://test.com/availableconstraint/*/*/*/~"
    query = AvailabilityQuery2.from({context: '*=*:*(~)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (key)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR/*/A.CH'
    query = AvailabilityQuery2.from({context: 'dataflow=*:EXR(*)', key: 'A.CH'})
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected
  
  it 'offers to skip default values (component)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR/*/*/FREQ'
    query = AvailabilityQuery2.from({context: 'dataflow=*:EXR(*)', component: 'FREQ'})
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (mode)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR\
    ?mode=available'
    query = AvailabilityQuery2.from({context: 'dataflow=*:EXR(*)', mode: 'available'})
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (refs)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR\
    ?references=codelist'
    query = AvailabilityQuery2.from({context: 'dataflow=*:EXR(*)', references: 'codelist'})
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (upd)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR?\
    updatedAfter=2016-03-01T00:00:00Z'
    query = AvailabilityQuery2.from({
      context: 'dataflow=*:EXR(*)'
      updatedAfter: '2016-03-01T00:00:00Z'})
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values (multi)', ->
    expected = 'http://test.com/availableconstraint/dataflow/*/EXR?\
    mode=available&updatedAfter=2016-03-01T00:00:00Z'
    query = AvailabilityQuery2.from({
      context: 'dataflow=*:EXR(*)'
      updatedAfter: '2016-03-01T00:00:00Z',
      mode: 'available'
      })
    service = Service.from({url: 'http://test.com', api: 'v2.0.0'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'throws an error when used against pre-SDMX 3.0 services', ->
    query = AvailabilityQuery2.from({context: 'dataflow=*:EXR(*)'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'SDMX 3.0 queries not allowed in v1.5.0')
