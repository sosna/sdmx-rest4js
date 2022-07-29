should = require('chai').should()

{Service} = require '../../src/service/service'
{ApiVersion} = require '../../src/utils/api-version'
{MetadataQuery} = require '../../src/metadata/metadata-query'
{UrlGenerator} = require '../../src/utils/url-generator'

describe 'URL Generator for metadata queries', ->

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
    service = Service.from(
      {url: "http://test.com/service/", api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'generates a URL for a metadata non-ItemScheme query', ->
    expected = "http://test.com/service/dataflow/all/all/\
    latest?detail=full&references=none"
    query = MetadataQuery.from({resource: 'dataflow'})
    service = Service.from(
      {url: "http://test.com/service/", api: ApiVersion.v1_5_0})
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
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
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
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_4_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'hierarchicalcodelist not allowed in v2.0.0')

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

  it 'Does not support multiple artefact types before API version 2.0.0', ->
    query = MetadataQuery.from({resource: 'codelist+dataflow'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'codelist+dataflow not allowed in v1.5.0')

  it 'Supports multiple artefact types since API 2.0.0', ->
    expected = "http://test.com/structure/codelist,dataflow/*/*/~\
    ?detail=full&references=none"
    query = MetadataQuery.from({resource: 'codelist,dataflow'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist,dataflow"
    query = MetadataQuery.from({resource: 'codelist,dataflow'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'Rewrites + for multiple artefact types in API 2.0.0', ->
    expected = "http://test.com/structure/codelist,dataflow/*/*/~\
    ?detail=full&references=none"
    query = MetadataQuery.from({resource: 'codelist+dataflow'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist,dataflow"
    query = MetadataQuery.from({resource: 'codelist+dataflow'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'Supports all for artefact types via * since API 2.0.0', ->
    expected = "http://test.com/structure/*/*/*/~\
    ?detail=full&references=none"
    query = MetadataQuery.from({resource: '*'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/*"
    query = MetadataQuery.from({resource: '*'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'supports multiple agencies for API version 1.3.0 and above', ->
    expected = "http://test.com/codelist/ECB+BIS/CL_FREQ/latest/all\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB+BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist/ECB,BIS/CL_FREQ/~/*\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB,BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
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

  it 'Rewrites , for multiple agencies before API version 2.0.0', ->
    expected = "http://test.com/codelist/ECB+BIS/CL_FREQ/latest/all\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB,BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'Rewrites + for multiple agencies since API 2.0.0', ->
    expected = "http://test.com/structure/codelist/ECB,BIS/CL_FREQ/~/*\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB+BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist/ECB,BIS/CL_FREQ"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB+BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'Rewrites * for agencies before API version 2.0.0', ->
    expected = "http://test.com/codelist/all/CL_FREQ/latest/all\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: '*'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/codelist/all/CL_FREQ"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: '*'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'Rewrites all for agencies since API 2.0.0', ->
    expected = "http://test.com/structure/codelist/*/CL_FREQ/~/*\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'all'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist/*/CL_FREQ"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'all'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'supports multiple IDs for API version 1.3.0 and above', ->
    expected = "http://test.com/codelist/ECB/CL_FREQ+CL_DECIMALS/latest/all\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ+CL_DECIMALS'
      agency: 'ECB'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

  it 'does not support multiple IDs before API version 1.3.0', ->
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ+CL_DECIMALS'
      agency: 'ECB'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'Multiple IDs not allowed in v1.2.0')

  it 'Rewrites , for multiple resource IDs before API version 2.0.0', ->
    expected = "http://test.com/codelist/BIS/CL_FREQ+CL_DECIMALS/latest/all\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ,CL_DECIMALS'
      agency: 'BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/codelist/BIS/CL_FREQ+CL_DECIMALS"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ,CL_DECIMALS'
      agency: 'BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'Rewrites + for multiple resource IDs since API 2.0.0', ->
    expected = "http://test.com/structure/codelist/BIS/CL_FREQ,CL_UNIT/~/*\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ+CL_UNIT'
      agency: 'BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist/BIS/CL_FREQ,CL_UNIT"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ+CL_UNIT'
      agency: 'BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'Rewrites * for resource IDs before API version 2.0.0', ->
    expected = "http://test.com/codelist/BIS/all/latest/all\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: '*'
      agency: 'BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/codelist/BIS/all/1.0"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: '*'
      agency: 'BIS'
      version: '1.0'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'Rewrites all for resources IDs since API 2.0.0', ->
    expected = "http://test.com/structure/codelist/BIS/*/~/*\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'all'
      agency: 'BIS'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist/BIS/*/1.0"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'all'
      agency: 'BIS'
      version: '1.0'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'supports multiple versions for API version 1.3.0 and above', ->
    expected = "http://test.com/codelist/ECB/CL_FREQ/1.0+1.1/all\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB'
      version: '1.0+1.1'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist/ECB/CL_FREQ/1.0.0,1.1.0/*\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'ECB'
      version: '1.0.0,1.1.0'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
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
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
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

  it 'Rewrites + for multiple items since API 2.0.0', ->
    expected = "http://test.com/structure/codelist/BIS/CL_FREQ/~/A,M\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'BIS'
      item: 'A+M'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist/BIS/CL_FREQ/~/A,M"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'BIS'
      item: 'A+M'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'Rewrites * for items before API version 2.0.0', ->
    expected = "http://test.com/codelist/BIS/CL_FREQ/1.0/all\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'BIS'
      version: '1.0'
      item: '*'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/codelist/BIS/CL_FREQ/1.0"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'BIS'
      version: '1.0'
      item: '*'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'Rewrites all for items since API 2.0.0', ->
    expected = "http://test.com/structure/codelist/BIS/CL_FREQ/1.0/*\
    ?detail=full&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'BIS'
      version: '1.0'
      item: 'all'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist/BIS/CL_FREQ/1.0"
    query = MetadataQuery.from({
      resource: 'codelist'
      id: 'CL_FREQ'
      agency: 'BIS'
      version: '1.0'
      item: 'all'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip default values for metadata', ->
    expected = "http://test.com/codelist"
    query = MetadataQuery.from({resource: 'codelist'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (id)', ->
    expected = "http://test.com/codelist/all/CL_FREQ"
    query = MetadataQuery.from({resource: 'codelist', id: 'CL_FREQ'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (version)', ->
    expected = "http://test.com/codelist/all/all/42"
    query = MetadataQuery.from({resource: 'codelist', version: '42'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds them when needed (item)', ->
    expected = "http://test.com/codelist/all/all/latest/1"
    query = MetadataQuery.from({resource: 'codelist', item: '1'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_1_0})
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
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (references)', ->
    expected = "http://test.com/codelist?references=datastructure"
    query = MetadataQuery.from({
      resource: 'codelist'
      references: 'datastructure'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'offers to skip defaults but adds params when needed (detail & refs)', ->
    expected = "http://test.com/codelist?detail=allstubs&references=datastructure"
    query = MetadataQuery.from({
      resource: 'codelist'
      detail: 'allstubs'
      references: 'datastructure'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_0_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'supports referencepartial since v1.3.0', ->
    expected = "http://test.com/codelist?detail=referencepartial"
    query = MetadataQuery.from({
      resource: 'codelist'
      detail: 'referencepartial'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'supports allcompletestubs since v1.3.0', ->
    expected = "http://test.com/codelist?detail=allcompletestubs"
    query = MetadataQuery.from({
      resource: 'codelist'
      detail: 'allcompletestubs'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'supports referencecompletestubs since v1.3.0', ->
    expected = "http://test.com/codelist?detail=referencecompletestubs"
    query = MetadataQuery.from({
      resource: 'codelist'
      detail: 'referencecompletestubs'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'supports raw since 2.0.0', ->
    expected = "http://test.com/structure/codelist/*/*/~/*?\
    detail=raw&references=none"
    query = MetadataQuery.from({
      resource: 'codelist'
      detail: 'raw'
    })
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/codelist?detail=raw"
    query = MetadataQuery.from({
      resource: 'codelist'
      detail: 'raw'
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

  it 'does not support raw before v2.0.0', ->
    query = MetadataQuery.from({
      resource: 'codelist'
      detail: 'raw'
    })
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'raw not allowed in v1.5.0')

  it 'supports actualconstraint since v1.3.0 and until v2.0.0', ->
    expected = 'http://test.com/actualconstraint'
    query = MetadataQuery.from({resource: 'actualconstraint'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_4_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'supports allowedconstraint since v1.3.0 and until v2.0.0', ->
    expected = 'http://test.com/allowedconstraint'
    query = MetadataQuery.from({resource: 'allowedconstraint'})

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_4_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'allowedconstraint not allowed in v2.0.0')

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

  it 'supports actualconstraint since v1.3.0 and until v2.0.0', ->
    expected = 'http://test.com/actualconstraint'
    query = MetadataQuery.from({resource: 'actualconstraint'})

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_3_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_4_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

    service = Service.from({url: 'http://test.com', api: ApiVersion.v2_0_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'actualconstraint not allowed in v2.0.0')

  it 'supports VTL artefacts since v1.5.0 (type)', ->
    expected = 'http://test.com/transformationscheme'
    query = MetadataQuery.from({resource: 'transformationscheme'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'does not support VTL artefacts before v1.5.0 (type)', ->
    query = MetadataQuery.from({resource: 'transformationscheme'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'transformationscheme not allowed in v1.2.0')

  it 'supports VTL artefacts since v1.5.0 (references)', ->
    expected = 'http://test.com/codelist?references=transformationscheme'
    query = MetadataQuery.from({resource: 'codelist', references: 'transformationscheme'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'does not support VTL artefacts before v1.5.0 (references)', ->
    query = MetadataQuery.from({resource: 'codelist', references: 'transformationscheme'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_2_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'transformationscheme not allowed as reference in v1.2.0')

  it 'supports ancestors since v2.0.0 (references)', ->
    expected = 'http://test.com/structure/codelist?references=ancestors'
    query = MetadataQuery.from({resource: 'codelist', references: 'ancestors'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'does not support ancestors before v2.0.0 (references)', ->
    query = MetadataQuery.from({resource: 'codelist', references: 'ancestors'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'ancestors not allowed as reference in v1.5.0')

  it 'supports semver since v2.0.0 (version)', ->
    expected = 'http://test.com/structure/codelist/BIS/CL_FREQ/1.2+.0/*?\
    detail=full&references=none'
    query = MetadataQuery.from(
      {resource: 'codelist', agency: 'BIS', id: 'CL_FREQ', version: '1.2+.0'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = 'http://test.com/structure/codelist/BIS/CL_FREQ/1.2+.0'
    query = MetadataQuery.from(
      {resource: 'codelist', agency: 'BIS', id: 'CL_FREQ', version: '1.2+.0'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected

  it 'does not support semver before v2.0.0', ->
    query = MetadataQuery.from(
      {resource: 'dataflow', id: 'EXR', agency: 'ECB', version: '~'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'Semantic versioning not allowed in v1.5.0')

    query = MetadataQuery.from(
      {resource: 'dataflow', id: 'EXR', agency: 'ECB', version: '1.2+.42'})
    service = Service.from({url: 'http://test.com', api: ApiVersion.v1_5_0})
    test = -> new UrlGenerator().getUrl(query, service)
    should.Throw(test, Error, 'Semantic versioning not allowed in v1.5.0')

  it 'rewrites version keywords since v2.0.0', ->
    expected = "http://test.com/structure/dataflow/BIS/EXR/~\
    ?detail=full&references=none"
    query = MetadataQuery.from(
      {resource: 'dataflow', agency: 'BIS', id: 'EXR', version: 'latest'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service)
    url.should.equal expected

    expected = "http://test.com/structure/dataflow/BIS/EXR"
    query = MetadataQuery.from(
      {resource: 'dataflow', agency: 'BIS', id: 'EXR', version: 'latest'})
    service = Service.from({url: 'http://test.com'})
    url = new UrlGenerator().getUrl(query, service, true)
    url.should.equal expected
