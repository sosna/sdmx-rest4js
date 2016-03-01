should = require('chai').should()
assert = require('chai').assert

{MetadataDetail} = require '../src/metadata-detail.coffee'
{MetadataReferences} = require '../src/metadata-references.coffee'
{MetadataQuery} = require '../src/metadata-query.coffee'
{MetadataType} = require '../src/metadata-types.coffee'

describe 'Metadata query', ->

  it 'should have the expected properties', ->
    query = new MetadataQuery(MetadataType.CODELIST).build()
    query.should.be.an 'object'
    query.should.have.property 'resource'
    query.should.have.property 'agencyID'
    query.should.have.property 'resourceID'
    query.should.have.property 'version'
    query.should.have.property 'detail'
    query.should.have.property 'references'

  it 'should have the expected defaults', ->
    resource = MetadataType.CODELIST
    query = new MetadataQuery(resource).build()
    query.should.have.property('resource').that.equals resource
    query.should.have.property('agencyID').that.equals 'all'
    query.should.have.property('resourceID').that.equals 'all'
    query.should.have.property('version').that.equals 'latest'
    query.should.have.property('detail').that.equals MetadataDetail.FULL
    query.should.be.an('object').with.property('references')
      .that.equals MetadataReferences.NONE

  it 'should be possible to set an agency', ->
    agency = 'ECB'
    query = new MetadataQuery(MetadataType.CODELIST).agencyID(agency).build()
    query.should.have.property('agencyID').that.equals agency

    agency = 'ECB.DISS'
    query = new MetadataQuery(MetadataType.CODELIST).agencyID(agency).build()
    query.should.have.property('agencyID').that.equals agency

    agency = 'ECB.DISS1'
    query = new MetadataQuery(MetadataType.CODELIST).agencyID(agency).build()
    query.should.have.property('agencyID').that.equals agency

    agency = 'ECB_DISS1'
    query = new MetadataQuery(MetadataType.CODELIST).agencyID(agency).build()
    query.should.have.property('agencyID').that.equals agency

    agency = 'ECB-DISS1'
    query = new MetadataQuery(MetadataType.CODELIST).agencyId(agency).build()
    query.should.have.property('agencyID').that.equals agency

  it 'should be possible to set a resource id', ->
    id = 'CL_FREQ'
    query = new MetadataQuery(MetadataType.CODELIST).resourceID(id).build()
    query.should.have.property('resourceID').that.equals id

    id = 'CL-FREQ1'
    query = new MetadataQuery(MetadataType.CODELIST).resourceId(id).build()
    query.should.have.property('resourceID').that.equals id

  it 'should be possible to set a version', ->
    version = '1.0'
    query = new MetadataQuery(MetadataType.CODELIST).version(version).build()
    query.should.have.property('version').that.equals version

    version = 'all'
    query = new MetadataQuery(MetadataType.CODELIST).version(version).build()
    query.should.have.property('version').that.equals version

    version = 'latest'
    query = new MetadataQuery(MetadataType.CODELIST).version(version).build()
    query.should.have.property('version').that.equals version

    version = '1.0.0'
    query = new MetadataQuery(MetadataType.CODELIST).version(version).build()
    query.should.have.property('version').that.equals version

  it 'should be possible to set the desired amount of details', ->
    detail = MetadataDetail.ALL_STUBS
    query = new MetadataQuery(MetadataType.CODELIST).detail(detail).build()
    query.should.have.property('detail').that.equals detail

  it 'should be possible to resolve references', ->
    refs = MetadataReferences.PARENTS
    query = new MetadataQuery(MetadataType.CODELIST).references(refs).build()
    query.should.have.property('references').that.equals refs

  it 'should not be possible to not set a resource type', ->
    try
      query = new MetadataQuery().build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resources'

  it 'should not be possible to set an unknown resource type', ->
    try
      query = new MetadataQuery('test').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resources'

  it 'should not be possible to set an unknown value for detail', ->
    try
      query = new MetadataQuery(MetadataType.CODELIST).detail('test').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'details'

  it 'should not be possible to set an unknown value for references', ->
    try
      query = new MetadataQuery(MetadataType.CODELIST).references('ref').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'references'

  it 'should not be possible to set an invalid version', ->
    try
      query = new MetadataQuery(MetadataType.CODELIST).version('semver').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'version'

    try
      query = new MetadataQuery(MetadataType.CODELIST).version('1_2_3').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'version'

  it 'should not be possible to set an invalid resource id', ->
    try
      query = new MetadataQuery(MetadataType.CODELIST).resourceID('1A').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resource'

    try
      query = new MetadataQuery(MetadataType.CODELIST).resourceID(' ').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resource'

    try
      query = new MetadataQuery(MetadataType.CODELIST).resourceID('1$').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resource'

    try
      query = new MetadataQuery(MetadataType.CODELIST).resourceID('A.B').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resource'

    try
      query = new MetadataQuery(MetadataType.CODELIST).resourceID('_A').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resource'

    try
      query = new MetadataQuery(MetadataType.CODELIST).resourceID('-A').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resource'

  it 'should not be possible to set an invalid agency id', ->
    try
      query = new MetadataQuery(MetadataType.CODELIST).agencyID('1A').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'agencies'

    try
      query = new MetadataQuery(MetadataType.CODELIST).agencyID(' ').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'agencies'

    try
      query = new MetadataQuery(MetadataType.CODELIST).agencyID('1$').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'agencies'

    try
      query = new MetadataQuery(MetadataType.CODELIST).agencyID('_A').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'agencies'

    try
      query = new MetadataQuery(MetadataType.CODELIST).agencyID('-A').build()
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'agencies'

  it 'should be possible to get the default options', ->
    query = new MetadataQuery(MetadataType.CODELIST)
    query.should.have.property 'defaults'
    query.defaults.should.have.property 'resourceID'
    query.defaults.should.have.property 'agencyID'
    query.defaults.should.have.property 'version'
    query.defaults.should.have.property 'detail'
    query.defaults.should.have.property 'references'
    query.defaults.resourceID.should.equal 'all'
    query.defaults.agencyID.should.equal 'all'
    query.defaults.version.should.equal 'latest'
    query.defaults.detail.should.equal 'full'
    query.defaults.references.should.equal 'none'

  it 'should not be possible to change the default options', ->
    query = new MetadataQuery(MetadataType.CODELIST)
    query.should.have.property 'defaults'
    query.defaults.should.be.frozen

  it 'should be possible to pass an object with options to create the query', ->
    opts =
      resource: 'codelist'
      resourceID: 'test'
    query = MetadataQuery.from(opts)
    query.should.be.an 'object'
    query.should.have.property 'resource'
    query.should.have.property 'resourceID'
    query.should.have.property 'agencyID'
    query.should.have.property 'version'
    query.should.have.property 'detail'
    query.should.have.property 'references'
    query.resource.should.equal opts.resource
    query.resourceID.should.equal opts.resourceID
    query.agencyID.should.equal 'all'
    query.version.should.equal 'latest'
    query.detail.should.equal 'full'
    query.references.should.equal 'none'

  it 'should be possible to get the URI representation of a query', ->
    query = new MetadataQuery(MetadataType.CODELIST).build()
    query.should.be.an 'object'
    query.should.have.property 'uri'
    uri = '/codelist/all/all/latest?detail=full&references=none'
    query.uri.should.equal uri
