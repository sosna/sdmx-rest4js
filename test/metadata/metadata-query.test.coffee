should = require('chai').should()

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

    it 'a string representing multiple resource types can be used', ->
      type = 'codelist+dataflow'
      query = MetadataQuery.from({resource: type})
      query.should.have.property('resource').that.equals type

      type = 'codelist,dataflow'
      query = MetadataQuery.from({resource: type})
      query.should.have.property('resource').that.equals type

    it 'an array representing multiple resource types can be used', ->
      types = ['codelist', 'dataflow']
      query = MetadataQuery.from({resource: types})
      query.should.have.property('resource').that.equals 'codelist+dataflow'

    it 'the character representing all resource types can be used', ->
      type = '*'
      query = MetadataQuery.from({resource: type})
      query.should.have.property('resource').that.equals type

    it 'throws an exception if the resource type is not set', ->
      test = -> MetadataQuery.from({})
      should.Throw(test, Error, 'Not a valid metadata query')

    it 'throws an exception if the resource type is unknown', ->
      test = -> MetadataQuery.from({resource: 'test'})
      should.Throw(test, Error, 'Not a valid metadata query')

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

    it 'a string representing multiple agencies can be used', ->
      agency = 'ECB+BIS'
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, agency: agency})
      query.should.have.property('agency').that.equals agency

      agency = 'ECB,BIS'
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, agency: agency})
      query.should.have.property('agency').that.equals agency

    it 'an array representing multiple agencies can be used', ->
      agencies = ['ECB.DISS', 'BIS']
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, agency: agencies})
      query.should.have.property('agency').that.equals 'ECB.DISS+BIS'

    it 'a string representing all agencies can be used', ->
      agency = 'all'
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, agency: agency})
      query.should.have.property('agency').that.equals agency

      agency = '*'
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, agency: agency})
      query.should.have.property('agency').that.equals agency

    it 'throws an exception when the agency id is invalid', ->
      test = -> MetadataQuery.from({resource: 'codelist', agency: '1A'})
      should.Throw(test, Error, 'Not a valid metadata query')

      test = -> MetadataQuery.from({resource: 'codelist', agency: ' '})
      should.Throw(test, Error, 'Not a valid metadata query')

      test = -> MetadataQuery.from({resource: 'codelist', agency: '$1'})
      should.Throw(test, Error, 'Not a valid metadata query')

      test = -> MetadataQuery.from({resource: 'codelist', agency: '_A'})
      should.Throw(test, Error, 'Not a valid metadata query')

      test = -> MetadataQuery.from({resource: 'codelist', agency: '-A'})
      should.Throw(test, Error, 'Not a valid metadata query')

  describe 'when setting a resource id', ->

    it 'a string representing the resource id can be passed', ->
      id = 'CL_FREQ'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: id})
      query.should.have.property('id').that.equals id

      id = 'CL-FREQ1'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: id})
      query.should.have.property('id').that.equals id

    it 'a string representing multiple resource ids can be used', ->
      id = 'CL_FREQ+CL_DECIMALS'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: id})
      query.should.have.property('id').that.equals id

      id = 'CL_FREQ,CL_DECIMALS'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: id})
      query.should.have.property('id').that.equals id

    it 'an array representing multiple resource ids can be used', ->
      ids = ['CL_FREQ', 'CL_DECIMALS']
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: ids})
      query.should.have.property('id').that.equals 'CL_FREQ+CL_DECIMALS'

    it 'a string representing all resource ids can be used', ->
      id = 'all'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: id})
      query.should.have.property('id').that.equals id

      id = '*'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, id: id})
      query.should.have.property('id').that.equals id

    it 'throws an exception if the resource id is invalid', ->
      test = -> MetadataQuery.from({resource: 'codelist', id: ' '})
      should.Throw(test, Error, 'Not a valid metadata query')

      test = -> MetadataQuery.from({resource: 'codelist', id: 'A.B'})
      should.Throw(test, Error, 'Not a valid metadata query')

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

    it 'a string representing multiple versions can be used', ->
      version = '1.0+2.1.1'
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, version: version})
      query.should.have.property('version').that.equals version

    it 'an array representing multiple versions can be used', ->
      versions = ['1.0', '2.1.1']
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, version: versions})
      query.should.have.property('version').that.equals '1.0+2.1.1'

    it 'a semver string can be used', ->
      version = '1.0+.1'
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, version: version})
      query.should.have.property('version').that.equals version

      version = '~'
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, version: version})
      query.should.have.property('version').that.equals version

    it 'throws an exception if the version is invalid', ->
      test = -> MetadataQuery.from({resource: 'codelist', version: 'semver'})
      should.Throw(test, Error, 'Not a valid metadata query')

      test = -> MetadataQuery.from({resource: 'codelist', version: '1_2_3'})
      should.Throw(test, Error, 'Not a valid metadata query')

  describe 'when setting an item id', ->

    it 'a string representing the item id can be passed', ->
      item = 'A'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, item: item})
      query.should.have.property('item').that.equals item

    it 'throws an exception if the item id is invalid', ->
      test = -> MetadataQuery.from({resource: 'codelist', item: ' '})
      should.Throw(test, Error, 'Not a valid metadata query')

      test = -> MetadataQuery.from({resource: 'codelist', item: 'A*'})
      should.Throw(test, Error, 'Not a valid metadata query')

    it 'throws an exception when setting an item of a non item scheme query', ->
      test = -> MetadataQuery.from({resource: 'dataflow', item: 'A'})
      should.Throw(test, Error, 'Not a valid metadata query')

    it 'handles hierarchical codelists as item schemes', ->
      item = 'hierarchy'
      query = MetadataQuery.from(
        {resource: MetadataType.HIERARCHICAL_CODELIST, item: item})
      query.should.have.property('item').that.equals item

    it 'a string representing multiple items can be used', ->
      items = 'A+B'
      query = MetadataQuery.from({resource: MetadataType.CODELIST, item: items})
      query.should.have.property('item').that.equals items

    it 'an array representing multiple items can be used', ->
      items = ['A', 'B']
      query = MetadataQuery.from({resource: MetadataType.CODELIST, item: items})
      query.should.have.property('item').that.equals 'A+B'

  describe 'when setting the amount of details', ->

    it 'a string representing the amount of details can be passed', ->
      detail = MetadataDetail.ALL_STUBS
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, detail: detail})
      query.should.have.property('detail').that.equals detail

    it 'throws an exception of the value for detail is unknown', ->
      test = -> MetadataQuery.from({resource: 'dataflow', detail: 'test'})
      should.Throw(test, Error, 'Not a valid metadata query')

  describe 'when setting the references to be resolved', ->

    it 'a string representing the references to be resolved can be passed', ->
      refs = MetadataReferences.PARENTS
      query = MetadataQuery.from(
        {resource: MetadataType.CODELIST, references: refs})
      query.should.have.property('references').that.equals refs

    it 'throws an exception if the value for references is unknown', ->
      test = -> MetadataQuery.from({resource: 'dataflow', references: 'ref'})
      should.Throw(test, Error, 'Not a valid metadata query')
