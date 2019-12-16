should = require('chai').should()

{SchemaQuery} = require '../../src/schema/schema-query'
{SchemaContext} = require '../../src/schema/schema-context'

describe 'Schema query', ->

  it 'has the expected properties', ->
    q = 
      context: SchemaContext.DATA_STRUCTURE
      agency: 'BIS'
      id: 'BIS_CBS'
    query = SchemaQuery.from(q)
    query.should.be.an 'object'
    query.should.have.property 'context'
    query.should.have.property 'agency'
    query.should.have.property 'id'
    query.should.have.property 'version'
    query.should.have.property 'explicit'
    query.should.have.property 'obsDimension'

  it 'has the expected defaults', ->
    q = 
      context: SchemaContext.DATA_STRUCTURE
      agency: 'BIS'
      id: 'BIS_CBS'
    query = SchemaQuery.from(q)
    query.should.be.an 'object'
    query.should.have.property('context').that.equals q.context
    query.should.have.property('agency').that.equals q.agency
    query.should.have.property('id').that.equals q.id
    query.should.have.property('version').that.equals 'latest'
    query.should.have.property('explicit').that.is.false
    query.should.have.property('obsDimension').that.is.undefined

  describe 'when setting a context', ->
    it 'a string representing the context can be passed', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
      q = SchemaQuery.from(q)
      q.should.have.property('context').that.equals q.context

    it 'throws an exception if the context is not set', ->
      q = 
        agency: 'BIS'
        id: 'BIS_CBS'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

    it 'throws an exception if the context is unknown', ->
      q = 
        context: 'test'
        agency: 'BIS'
        id: 'BIS_CBS'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

  describe 'when setting an agency', ->

    it 'a string representing the agency id can be passed', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
      test = SchemaQuery.from(q)
      test.should.have.property('agency').that.equals q.agency

      q = 
        context: 'datastructure'
        agency: 'BIS.DISS1'
        id: 'BIS_CBS'
      test = SchemaQuery.from(q)
      test.should.have.property('agency').that.equals q.agency

    it 'a string representing multiple agencies cannot be used', ->
      q = 
        context: 'datastructure'
        agency: 'ECB+BIS'
        id: 'BIS_CBS'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

    it 'throws an exception when the agency id is invalid', ->
      q = 
        context: 'datastructure'
        agency: '1A'
        id: 'BIS_CBS'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

      q = 
        context: 'datastructure'
        agency: ' '
        id: 'BIS_CBS'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

      q = 
        context: 'datastructure'
        agency: '$1'
        id: 'BIS_CBS'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

      q = 
        context: 'datastructure'
        agency: '_A'
        id: 'BIS_CBS'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

      q = 
        context: 'datastructure'
        agency: '-A'
        id: 'BIS_CBS'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

  describe 'when setting a resource id', ->

    it 'a string representing the resource id can be passed', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
      test = SchemaQuery.from(q)
      test.should.have.property('id').that.equals q.id

      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS-CBS01'
      test = SchemaQuery.from(q)
      test.should.have.property('id').that.equals q.id

    it 'a string representing multiple resource ids cannot be used', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS+BIS_LBS'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

    it 'throws an exception if the resource id is invalid', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: ' '
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'A.B'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

  describe 'when setting a version', ->

    it 'a string representing the version can be passed', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
        version: '1.0'
      test = SchemaQuery.from(q)
      test.should.have.property('version').that.equals q.version

      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
        version: 'latest'
      test = SchemaQuery.from(q)
      test.should.have.property('version').that.equals q.version

      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
        version: '1.0.0'
      test = SchemaQuery.from(q)
      test.should.have.property('version').that.equals q.version

    it 'a string representing multiple versions cannot be used', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
        version: '1.0+2.1.1'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

    it 'throws an exception when requesting all versions', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
        version: 'all'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

    it 'throws an exception if the version is invalid', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
        version: 'semver'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
        version: '1_2_3'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')

  describe 'when setting whether measure is explicit', ->

    it 'a boolean can be passed', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
        version: '1.0'
        explicit: true
      test = SchemaQuery.from(q)
      test.should.have.property('explicit').that.is.true

    it 'throws an exception if explicit is not a boolean', ->
      q = 
        context: 'datastructure'
        agency: 'BIS'
        id: 'BIS_CBS'
        version: '1.0'
        explicit: 'test'
      test = -> SchemaQuery.from(q)
      should.Throw(test, Error, 'Not a valid schema query')