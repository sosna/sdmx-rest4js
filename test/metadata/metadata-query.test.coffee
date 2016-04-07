should = require('chai').should()
assert = require('chai').assert

{MetadataDetail} = require '../../src/metadata/metadata-detail'
{MetadataReferences} = require '../../src/metadata/metadata-references'
{MetadataQuery} = require '../../src/metadata/metadata-query'
{MetadataType} = require '../../src/metadata/metadata-type'

describe 'Metadata query', ->

  it 'has the expected properties', ->
    query = MetadataQuery.from({resource: MetadataType.CODELIST})
    query.should.be.an 'object'
    query.should.have.property 'resource'
    query.should.have.property 'agency'
    query.should.have.property 'id'
    query.should.have.property 'version'
    query.should.have.property 'detail'
    query.should.have.property 'references'
    query.should.have.property 'item'

  it 'has the expected defaults', ->
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

  describe 'when setting a resource type', ->
    it 'a string representing the resource type can be passed', ->
      resource = 'codelist'
      query = MetadataQuery.from({resource: resource})
      query.should.have.property('resource').that.equals resource

      resource = MetadataType.DATAFLOW
      query = MetadataQuery.from({resource: resource})
      query.should.have.property('resource').that.equals resource

    it 'throws an exception if the resource type is not set', ->
      try
        MetadataQuery.from({})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'resources'

    it 'throws an exception if the resource type is unknown', ->
      try
        MetadataQuery.from({resource: 'test'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'resources'

  describe 'when setting an agency', ->

    it 'a string representing the agency id can be passed', ->
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

    it 'throws an exception when the agency id is invalid', ->
      try
        MetadataQuery.from({resource: MetadataType.CODELIST, agency: '1A'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'agencies'

      try
        MetadataQuery.from({resource: MetadataType.CODELIST, agency: ' '})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'agencies'

      try
        MetadataQuery.from({resource: MetadataType.CODELIST, agency: '1$'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'agencies'

      try
        MetadataQuery.from({resource: MetadataType.CODELIST, agency: '_A'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'agencies'

      try
        MetadataQuery.from({resource: MetadataType.CODELIST, agency: '-A'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'agencies'

  describe 'when setting a resource id', ->

    it 'a string representing the resource id can be passed', ->
      id = 'CL_FREQ'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: id})
      query.should.have.property('id').that.equals id

      id = 'CL-FREQ1'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: id})
      query.should.have.property('id').that.equals id

    it 'throws an exception if the resource id is invalid', ->
      try
        MetadataQuery.from({resource: MetadataType.CODELIST, id: ' '})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'resource'

      try
        MetadataQuery.from({resource: MetadataType.CODELIST, id: 'A.B'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'resource'

  describe 'when setting a version', ->

    it 'a string representing the version can be passed', ->
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

    it 'throws an exception if the version is invalid', ->
      try
        MetadataQuery.from({resource: MetadataType.CODELIST, version: 'semver'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'version'

      try
        MetadataQuery.from({resource: MetadataType.CODELIST, version: '1_2_3'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'version'

  describe 'when setting an item id', ->

    it 'a string representing the item id can be passed', ->
      item = 'A'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, item: item})
      query.should.have.property('item').that.equals item

    it 'throws an exception if the item id is invalid', ->
      try
        MetadataQuery.from({resource: MetadataType.CODELIST, item: ' '})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'item'

      try
        MetadataQuery.from({resource: MetadataType.CODELIST, item: 'A*'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'item'

    it 'throws an exception when setting an item of a non item scheme query', ->
      try
        MetadataQuery.from({resource: MetadataType.DATAFLOW, item: 'A'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'item scheme'

  describe 'when setting the amount of details', ->

    it 'a string representing the amount of details can be passed', ->
      detail = MetadataDetail.ALL_STUBS
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, detail: detail})
      query.should.have.property('detail').that.equals detail

    it 'throws an exception of the value for detail is unknown', ->
      try
        MetadataQuery.from({resource: MetadataType.CODELIST, detail: 'test'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'details'

  describe 'when setting the references to be resolved', ->

    it 'a string representing the references to be resolved can be passed', ->
      refs = MetadataReferences.PARENTS
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, references: refs})
      query.should.have.property('references').that.equals refs

    it 'throws an exception if the value for references is unknown', ->
      try
        query = MetadataQuery.from(
          {resource: MetadataType.CODELIST, references: 'ref'})
        assert.fail 'An error should have been triggered'
      catch error
        error.message.should.contain 'Not a valid metadata query'
        error.message.should.contain 'references'
