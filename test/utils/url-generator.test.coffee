should = require('chai').should()

{Service} = require '../../src/service/service'
{ApiVersion} = require '../../src/utils/api-version'
{DataQuery} = require '../../src/data/data-query'
{MetadataQuery} = require '../../src/metadata/metadata-query'
{AvailabilityQuery} = require '../../src/avail/availability-query'
{SchemaQuery} = require '../../src/schema/schema-query'
{UrlGenerator} = require '../../src/utils/url-generator'

describe 'URL Generator', ->

  describe 'for metadata queries', ->

    it 'generates a URL for a metadata query', ->
      expected = "http://sdw-wsrest.ecb.europa.eu/service/codelist/ECB/CL_FREQ/\
      latest?detail=full&references=none"
      query =
        MetadataQuery.from({resource: 'codelist', id: 'CL_FREQ', agency: 'ECB'})
      service = Service.ECB
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'generates a URL for a metadata ItemScheme query', ->
      expected = "http://test.com/service/codelist/all/all/\
      latest/all?detail=full&references=none"
      query = MetadataQuery.from({resource: 'codelist'})
      service = Service.from({url: "http://test.com/service/"})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'generates a URL for a metadata non-ItemScheme query', ->
      expected = "http://test.com/service/dataflow/all/all/\
      latest?detail=full&references=none"
      query = MetadataQuery.from({resource: 'dataflow'})
      service = Service.from({url: "http://test.com/service/"})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'supports item queries for API version 1.1.0 and above', ->
      expected = "http://test.com/codelist/ECB/CL_FREQ/latest/A\
      ?detail=full&references=none"
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ'
        agency: 'ECB'
        item: 'A'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'does not support item queries before API version 1.1.0', ->
      expected = "http://test.com/codelist/ECB/CL_FREQ/latest\
      ?detail=full&references=none"
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ'
        agency: 'ECB'
        item: 'A'
      })
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_2})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'treats hierarchical codelists as item schemes for API version 1.2.0', ->
      expected = "http://test.com/hierarchicalcodelist/BIS/HCL/latest/HIERARCHY\
      ?detail=full&references=none"
      query = MetadataQuery.from({
        resource: 'hierarchicalcodelist'
        id: 'HCL'
        agency: 'BIS'
        item: 'HIERARCHY'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'does not support hiearchy queries before API version 1.2.0', ->
      expected = "http://test.com/hierarchicalcodelist/BIS/HCL/latest\
      ?detail=full&references=none"
      query = MetadataQuery.from({
        resource: 'hierarchicalcodelist'
        id: 'HCL'
        agency: 'BIS'
        item: 'HIERARCHY'
      })
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_1_0})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'supports multiple agencies for API version 1.3.0 and above', ->
      expected = "http://test.com/codelist/ECB+BIS/CL_FREQ/latest/all\
      ?detail=full&references=none"
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ'
        agency: 'ECB+BIS'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'does not support multiple agencies before API version 1.3.0', ->
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ'
        agency: 'ECB+BIS'
      })
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
      test = -> new UrlGenerator().getUrl(query, service)
      should.Throw(test, Error, 'Multiple agencies not allowed in v1.2.0')

    it 'supports multiple IDs for API version 1.3.0 and above', ->
      expected = "http://test.com/codelist/ECB/CL_FREQ+CL_DECIMALS/latest/all\
      ?detail=full&references=none"
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ+CL_DECIMALS'
        agency: 'ECB'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'does not support multiple agencies before API version 1.3.0', ->
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ+CL_DECIMALS'
        agency: 'ECB'
      })
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
      test = -> new UrlGenerator().getUrl(query, service)
      should.Throw(test, Error, 'Multiple IDs not allowed in v1.2.0')

    it 'supports multiple versions for API version 1.3.0 and above', ->
      expected = "http://test.com/codelist/ECB/CL_FREQ/1.0+1.1/all\
      ?detail=full&references=none"
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ'
        agency: 'ECB'
        version: '1.0+1.1'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'does not support multiple versions before API version 1.3.0', ->
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ'
        agency: 'ECB'
        version: '1.0+1.1'
      })
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_1_0})
      test = -> new UrlGenerator().getUrl(query, service)
      should.Throw(test, Error, 'Multiple versions not allowed in v1.1.0')

    it 'supports multiple items for API version 1.3.0 and above', ->
      expected = "http://test.com/codelist/ECB/CL_FREQ/1.0/A+M\
      ?detail=full&references=none"
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ'
        agency: 'ECB'
        version: '1.0'
        item: 'A+M'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'does not support multiple items before API version 1.3.0', ->
      query = MetadataQuery.from({
        resource: 'codelist'
        id: 'CL_FREQ'
        agency: 'ECB'
        version: '1.0'
        item: 'A+M'
      })
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
      test = -> new UrlGenerator().getUrl(query, service)
      should.Throw(test, Error, 'Multiple items not allowed in v1.2.0')

    it 'defaults to latest API version', ->
      expected = "http://test.com/hierarchicalcodelist/ECB/HCL/latest/HIERARCHY\
      ?detail=full&references=none"
      query = MetadataQuery.from({
        resource: 'hierarchicalcodelist'
        id: 'HCL'
        agency: 'ECB'
        item: 'HIERARCHY'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'offers to skip default values for metadata', ->
      expected = "http://test.com/codelist"
      query = MetadataQuery.from({resource: 'codelist'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds them when needed (id)', ->
      expected = "http://test.com/codelist/all/CL_FREQ"
      query = MetadataQuery.from({resource: 'codelist', id: 'CL_FREQ'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds them when needed (version)', ->
      expected = "http://test.com/codelist/all/all/42"
      query = MetadataQuery.from({resource: 'codelist', version: '42'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds them when needed (item)', ->
      expected = "http://test.com/codelist/all/all/latest/1"
      query = MetadataQuery.from({resource: 'codelist', item: '1'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds them when needed (item, old API)', ->
      expected = "http://test.com/codelist"
      query = MetadataQuery.from({resource: 'codelist', item: '1'})
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_2})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (detail)', ->
      expected = "http://test.com/codelist?detail=allstubs"
      query = MetadataQuery.from({resource: 'codelist', detail: 'allstubs'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (references)', ->
      expected = "http://test.com/codelist?references=datastructure"
      query = MetadataQuery.from({
        resource: 'codelist'
        references: 'datastructure'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (detail & refs)', ->
      expected = "http://test.com/codelist?detail=allstubs&references=datastructure"
      query = MetadataQuery.from({
        resource: 'codelist'
        detail: 'allstubs'
        references: 'datastructure'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'supports referencepartial since v1.3.0', ->
      expected = "http://test.com/codelist?detail=referencepartial"
      query = MetadataQuery.from({
        resource: 'codelist'
        detail: 'referencepartial'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'supports allcompletestubs since v1.3.0', ->
      expected = "http://test.com/codelist?detail=allcompletestubs"
      query = MetadataQuery.from({
        resource: 'codelist'
        detail: 'allcompletestubs'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'supports referencecompletestubs since v1.3.0', ->
      expected = "http://test.com/codelist?detail=referencecompletestubs"
      query = MetadataQuery.from({
        resource: 'codelist'
        detail: 'referencecompletestubs'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'does not support referencepartial before v1.3.0', ->
      query = MetadataQuery.from({
        resource: 'codelist'
        detail: 'referencepartial'
      })
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_1_0})
      test = -> new UrlGenerator().getUrl(query, service)
      should.Throw(test, Error, 'referencepartial not allowed in v1.1.0')

    it 'does not support allcompletestubs before v1.3.0', ->
      query = MetadataQuery.from({
        resource: 'codelist'
        detail: 'allcompletestubs'
      })
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
      test = -> new UrlGenerator().getUrl(query, service)
      should.Throw(test, Error, 'allcompletestubs not allowed in v1.2.0')

    it 'does not support referencecompletestubs before v1.3.0', ->
      query = MetadataQuery.from({
        resource: 'codelist'
        detail: 'referencecompletestubs'
      })
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_2})
      test = -> new UrlGenerator().getUrl(query, service)
      should.Throw(test, Error, 'referencecompletestubs not allowed in v1.0.2')

    it 'supports actualconstraint since v1.3.0', ->
      expected = 'http://test.com/actualconstraint'
      query = MetadataQuery.from({resource: 'actualconstraint'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'supports allowedconstraint since v1.3.0', ->
      expected = 'http://test.com/allowedconstraint'
      query = MetadataQuery.from({resource: 'allowedconstraint'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'does not support actualconstraint before v1.3.0', ->
      query = MetadataQuery.from({resource: 'actualconstraint'})
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
      test = -> new UrlGenerator().getUrl(query, service)
      should.Throw(test, Error, 'actualconstraint not allowed in v1.2.0')

    it 'does not support allowedconstraint before v1.3.0', ->
      query = MetadataQuery.from({resource: 'allowedconstraint'})
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_2})
      test = -> new UrlGenerator().getUrl(query, service)
      should.Throw(test, Error, 'allowedconstraint not allowed in v1.0.2')

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
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'generates a URL for a partial data query', ->
      expected = "http://test.com/data/EXR/A..EUR.SP00.A/all?\
      dimensionAtObservation=TIME_PERIOD&detail=full&includeHistory=false"
      query = DataQuery.from({flow: 'EXR', key: 'A..EUR.SP00.A'})
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_1_0})
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
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service)
      url.should.equal expected

    it 'offers to skip default values for data', ->
      expected = "http://test.com/data/EXR"
      query = DataQuery.from({flow: 'EXR'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds them when needed (provider)', ->
      expected = "http://test.com/data/EXR/all/ECB"
      query = DataQuery.from({flow: 'EXR', provider: 'ECB'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (start)', ->
      expected = "http://test.com/data/EXR?startPeriod=2010"
      query = DataQuery.from({flow: 'EXR', start: '2010'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (end)', ->
      expected = "http://test.com/data/EXR?endPeriod=2010"
      query = DataQuery.from({flow: 'EXR', end: '2010'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (updatedAfter)', ->
      expected = "http://test.com/data/EXR?updatedAfter=2016-03-01T00:00:00Z"
      query = DataQuery.from({
        flow: 'EXR'
        updatedAfter: '2016-03-01T00:00:00Z'
      })
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (firstNObs)', ->
      expected = "http://test.com/data/EXR?firstNObservations=1"
      query = DataQuery.from({flow: 'EXR', firstNObs: 1})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (lastNObs)', ->
      expected = "http://test.com/data/EXR?lastNObservations=2"
      query = DataQuery.from({flow: 'EXR', lastNObs: 2})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (detail)', ->
      expected = "http://test.com/data/EXR?detail=dataonly"
      query = DataQuery.from({flow: 'EXR', detail: 'dataonly'})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (history)', ->
      expected = "http://test.com/data/EXR?includeHistory=true"
      query = DataQuery.from({flow: 'EXR', history: true})
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'offers to skip defaults but adds params when needed (obsDim)', ->
      expected = "http://test.com/data/EXR?dimensionAtObservation=CURR"
      query = DataQuery.from({flow: 'EXR', obsDimension: 'CURR'})
      service = Service.from({url: 'http://test.com'})
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
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'supports multiple providers for API version 1.3.0 and above', ->
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
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected

    it 'does not support providers before API version 1.3.0', ->
      query = DataQuery.from({flow: 'EXR', provider: 'SDMX,ECB+BIS'})
      service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
      test = -> new UrlGenerator().getUrl(query, service)
      should.Throw(test, Error, 'Multiple providers not allowed in v1.2.0')

  it 'throws an exception if no query is supplied', ->
    test = -> new UrlGenerator().getUrl()
    should.Throw(test, Error,
      'not a valid SDMX data, metadata or availability query')

  it 'throws an exception if the input is not a data or a metadata query', ->
    test = -> new UrlGenerator().getUrl({test: 'Test'})
    should.Throw(test, TypeError,
      'not a valid SDMX data, metadata or availability query')

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

describe 'for availability queries', ->

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
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'generates a URL for a partial availability query', ->
    expected = 'http://test.com/availableconstraint/EXR/A..EUR.SP00.A/all/all?\
    mode=exact&references=none'
    query = AvailabilityQuery.from({flow: 'EXR', key: 'A..EUR.SP00.A'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'supports minimal query if proper query class is used', ->
    expected = 'http://test.com/availableconstraint/EXR/all/all/all?\
    mode=exact&references=none'
    query = AvailabilityQuery.from({flow: 'EXR'})
    service = Service.from({url: 'http://test.com'})
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
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (provider)', ->
    expected = 'http://test.com/availableconstraint/EXR/all/ECB'
    query = AvailabilityQuery.from({flow: 'EXR', provider: 'ECB'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (component)', ->
    expected = 'http://test.com/availableconstraint/EXR/all/all/FREQ'
    query = AvailabilityQuery.from({flow: 'EXR', component: 'FREQ'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (mode)', ->
    expected = 'http://test.com/availableconstraint/EXR?mode=available'
    query = AvailabilityQuery.from({flow: 'EXR', mode: 'available'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (references)', ->
    expected = 'http://test.com/availableconstraint/EXR?references=codelist'
    query = AvailabilityQuery.from({flow: 'EXR', references: 'codelist'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (start)', ->
    expected = 'http://test.com/availableconstraint/EXR?startPeriod=2007'
    query = AvailabilityQuery.from({flow: 'EXR', start: '2007'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (end)', ->
    expected = 'http://test.com/availableconstraint/EXR?endPeriod=2073'
    query = AvailabilityQuery.from({flow: 'EXR', end: '2073'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (start & ed)', ->
    expected = 'http://test.com/availableconstraint/EXR?startPeriod=2007&\
    endPeriod=2073'
    query = AvailabilityQuery.from({flow: 'EXR', start: '2007', end: '2073'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (end)', ->
    expected = 'http://test.com/availableconstraint/EXR?endPeriod=2073'
    query = AvailabilityQuery.from({flow: 'EXR', end: '2073'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (updatedAfter)', ->
    expected = 'http://test.com/availableconstraint/EXR?\
    updatedAfter=2016-03-01T00:00:00Z'
    query = AvailabilityQuery.from({
      flow: 'EXR'
      updatedAfter: '2016-03-01T00:00:00Z'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

describe 'for schema queries', ->

    it 'generates a URL for a schema query', ->
      expected = "http://sdw-wsrest.ecb.europa.eu/service/schema/dataflow\
      /ECB/EXR/latest?explicitMeasure=false"
      query = SchemaQuery.from({context: 'dataflow', id: 'EXR', agency: 'ECB'})
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
      service = Service.from({url: 'http://test.com'})
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
      service = Service.from({url: 'http://test.com'})
      url = new UrlGenerator().getUrl(query, service, true)
      url.should.equal expected
