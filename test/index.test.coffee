sdmxrest = require '../src/index'
{ApiVersion} = require '../src/utils/api-version'

describe 'API', ->

  it 'should have the expected functions', ->
    sdmxrest.should.have.property 'getService'
    sdmxrest.should.have.property 'getDataQuery'
    sdmxrest.should.have.property 'getMetadataQuery'
    sdmxrest.should.have.property 'getUrl'
    sdmxrest.should.have.property('data').that.is.an 'object'
    sdmxrest.should.have.property('metadata').that.is.an 'object'
    sdmxrest.should.have.property('utils').that.is.an 'object'
    sdmxrest.should.have.property('data').that.is.an 'object'
    sdmxrest.data.should.have.property 'DataFormat'
    sdmxrest.data.should.have.property 'DataDetail'
    sdmxrest.metadata.should.have.property 'MetadataDetail'
    sdmxrest.metadata.should.have.property 'MetadataFormat'
    sdmxrest.metadata.should.have.property 'MetadataReferences'
    sdmxrest.metadata.should.have.property 'MetadataType'
    sdmxrest.utils.should.have.property 'ApiVersion'
    sdmxrest.utils.should.have.property 'SdmxPatterns'

  it 'should offer to get an existing service', ->
    service = sdmxrest.getService 'ECB'
    service.should.be.an 'object'
    service.should.have.property('id').that.equals 'ECB'
    service.should.have.property('name').that.equals 'European Central Bank'
    service.should.have.property('url').that.contains 'sdw-wsrest'
    service.should.have.property('api').that.is.not.undefined

  it 'should offer to create a service from properties', ->
    input = {
      id: 'TEST'
      url: 'http://test.com'
    }
    service = sdmxrest.getService input
    service.should.be.an 'object'
    service.should.have.property('id').that.equals input.id
    service.should.have.property('name').that.is.undefined
    service.should.have.property('url').that.equals input.url
    service.should.have.property('api').that.equals ApiVersion.LATEST

  it 'should fail if the service is unknown', ->
    try
      sdmxrest.getService 'UNKNOWN'
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Unknown or invalid service'

  it 'should fail if the input to service is not of the expected type', ->
    try
      sdmxrest.getService 2
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Unknown or invalid service'

    try
      sdmxrest.getService undefined
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Unknown or invalid service'

  it 'should offer to create a data query from properties', ->
    input = {
      flow: 'EXR'
      key: 'A..EUR.SP00.A'
    }
    query = sdmxrest.getDataQuery input
    query.should.be.an 'object'
    query.should.have.property('flow').that.equals input.flow
    query.should.have.property('key').that.equals input.key
    query.should.have.property('provider').that.equals 'all'
    query.should.have.property('start').that.is.undefined
    query.should.have.property('end').that.is.undefined
    query.should.have.property('updatedAfter').that.is.undefined
    query.should.have.property('firstNObs').that.is.undefined
    query.should.have.property('lastNObs').that.is.undefined
    query.should.have.property('obsDimension').that.equals 'TIME_PERIOD'
    query.should.have.property('detail').that.equals 'full'
    query.should.have.property('history').that.is.false

  it 'should fail if input to data query is not of the expected type', ->
    try
      sdmxrest.getDataQuery undefined
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'

    try
      sdmxrest.getDataQuery {test: 'TEST'}
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid data query'

  it 'should offer to create a metadata query from properties', ->
    input = {
      resource: 'codelist'
      id: 'CL_FREQ'
    }
    query = sdmxrest.getMetadataQuery input
    query.should.be.an 'object'
    query.should.have.property('resource').that.equals input.resource
    query.should.have.property('id').that.equals input.id
    query.should.have.property('agency').that.equals 'all'
    query.should.have.property('version').that.equals 'latest'
    query.should.have.property('item').that.equals 'all'
    query.should.have.property('detail').that.equals 'full'
    query.should.have.property('references').that.equals 'none'

  it 'should fail if input to metadata query is not of the expected type', ->
    try
      sdmxrest.getMetadataQuery undefined
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'

    try
      sdmxrest.getMetadataQuery {test: 'TEST'}
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'

  it 'should offer to create a URL from a query and a service', ->
    query = sdmxrest.getDataQuery {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}
    service = sdmxrest.getService 'ECB'
    url = sdmxrest.getUrl query, service
    url.should.be.a 'string'
    url.should.contain service.url
    url.should.contain query.flow
    url.should.contain query.key

  it 'should offer to create a URL from partial metadata query and service', ->
    url = sdmxrest.getUrl {resource: 'codelist', id: 'CL_FREQ'}, 'ECB'
    url.should.be.a 'string'
    url.should.contain 'sdw-wsrest.ecb.europa.eu'
    url.should.contain 'codelist'
    url.should.contain 'CL_FREQ'

  it 'should fail if input to URL are not of the expected types', ->
    try
      sdmxrest.getUrl undefined, sdmxrest.getService 'ECB'
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid query'

    query = sdmxrest.getDataQuery {flow: 'EXR', key: 'A.CHF.NOK.SP00.A'}

    try
      sdmxrest.getUrl query, sdmxrest.getService 'TEST'
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Unknown or invalid service'

    try
      sdmxrest.getUrl query
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Unknown or invalid service'
