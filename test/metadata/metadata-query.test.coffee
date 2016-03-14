should = require('chai').should()
assert = require('chai').assert

{MetadataDetail} = require '../../src/metadata/metadata-detail'
{MetadataReferences} = require '../../src/metadata/metadata-references'
{MetadataQuery} = require '../../src/metadata/metadata-query'
{MetadataType} = require '../../src/metadata/metadata-type'

describe 'Metadata query', ->

  it 'should have the expected properties', ->
    query = MetadataQuery.from({resource: MetadataType.CODELIST})
    query.should.be.an 'object'
    query.should.have.property 'resource'
    query.should.have.property 'agency'
    query.should.have.property 'id'
    query.should.have.property 'version'
    query.should.have.property 'detail'
    query.should.have.property 'references'
    query.should.have.property 'item'

  it 'should have the expected defaults', ->
    resource = MetadataType.CODELIST
    query = MetadataQuery.from({resource: resource})
    query.should.have.property('resource').that.equals resource
    query.should.have.property('agency').that.equals 'all'
    query.should.have.property('id').that.equals 'all'
    query.should.have.property('version').that.equals 'latest'
    query.should.have.property('item').that.equals 'all'
    query.should.have.property('detail').that.equals MetadataDetail.FULL
    query.should.be.an('object').with.property('references')
      .that.equals MetadataReferences.NONE

  it 'should be possible to set an agency', ->
    agency = 'ECB'
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, agency: agency})
    query.should.have.property('agency').that.equals agency

    agency = 'ECB.DISS'
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, agency: agency})
    query.should.have.property('agency').that.equals agency

    agency = 'ECB.DISS1'
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, agency: agency})
    query.should.have.property('agency').that.equals agency

    agency = 'ECB_DISS1'
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, agency: agency})
    query.should.have.property('agency').that.equals agency

    agency = 'ECB-DISS1'
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, agency: agency})
    query.should.have.property('agency').that.equals agency

  it 'should be possible to set a resource id', ->
    id = 'CL_FREQ'
    query = MetadataQuery.from({resource: MetadataType.CODELIST, id: id})
    query.should.have.property('id').that.equals id

    id = 'CL-FREQ1'
    query = MetadataQuery.from({resource: MetadataType.CODELIST, id: id})
    query.should.have.property('id').that.equals id

  it 'should be possible to set a version', ->
    version = '1.0'
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, version: version})
    query.should.have.property('version').that.equals version

    version = 'all'
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, version: version})
    query.should.have.property('version').that.equals version

    version = 'latest'
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, version: version})
    query.should.have.property('version').that.equals version

    version = '1.0.0'
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, version: version})
    query.should.have.property('version').that.equals version

  it 'should be possible to set the desired amount of details', ->
    detail = MetadataDetail.ALL_STUBS
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, detail: detail})
    query.should.have.property('detail').that.equals detail

  it 'should be possible to resolve references', ->
    refs = MetadataReferences.PARENTS
    query = MetadataQuery.from(
      {resource: MetadataType.CODELIST, references: refs})
    query.should.have.property('references').that.equals refs

  it 'should be possible to set an item id', ->
    item = 'A'
    query = MetadataQuery.from({resource: MetadataType.CODELIST, item: item})
    query.should.have.property('item').that.equals item

  it 'should be possible to set an item id via the from method', ->
    item = 'A'
    query = MetadataQuery.from({
      resource: MetadataType.CODELIST
      item: item
    })
    query.should.have.property('item').that.equals item

  it 'should not be possible to not set a resource type', ->
    try
      query = MetadataQuery.from({})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resources'

  it 'should not be possible to set an unknown resource type', ->
    try
      query = MetadataQuery.from({resource: 'test'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resources'

  it 'should not be possible to set an unknown value for detail', ->
    try
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, detail: 'test'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'details'

  it 'should not be possible to set an unknown value for references', ->
    try
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, references: 'ref'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'references'

  it 'should not be possible to set an invalid version', ->
    try
      query =
        MetadataQuery.from({resource: MetadataType.CODELIST, version: 'semver'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'version'

    try
      query =
        MetadataQuery.from({resource: MetadataType.CODELIST, version: '1_2_3'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'version'

  it 'should not be possible to set an invalid resource id', ->
    try
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: ' '})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resource'

    try
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: 'A.B'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'resource'

  it 'should not be possible to set an invalid agency id', ->
    try
      query =
        MetadataQuery.from({resource: MetadataType.CODELIST, agency: '1A'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'agencies'

    try
      query = MetadataQuery.from({resource: MetadataType.CODELIST, agency: ' '})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'agencies'

    try
      query =
        MetadataQuery.from({resource: MetadataType.CODELIST, agency: '1$'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'agencies'

    try
      query =
        MetadataQuery.from({resource: MetadataType.CODELIST, agency: '_A'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'agencies'

    try
      query =
        MetadataQuery.from({resource: MetadataType.CODELIST, agency: '-A'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'agencies'

  it 'should not be possible to set an invalid item', ->
    try
      query = MetadataQuery.from({resource: MetadataType.CODELIST, item: ' '})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'item'

    try
      query = MetadataQuery.from({resource: MetadataType.CODELIST, item: 'A*'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'item'

  it 'should not be possible to set an item when not an item scheme query', ->
    try
      query = MetadataQuery.from({resource: MetadataType.DATAFLOW, item: 'A'})
      assert.fail 'An error should have been triggered'
    catch error
      error.message.should.contain 'Not a valid metadata query'
      error.message.should.contain 'item scheme'
