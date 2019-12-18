should = require('chai').should()

{SchemaContext} = require '../../src/schema/schema-context'

describe 'Schema context', ->

  expectedContexts = [
    'datastructure'
    'metadatastructure'
    'dataflow'
    'metadataflow'
    'provisionagreement'
  ]

  it 'contains all the expected contexts and only those', ->
    count = 0
    for key, value of SchemaContext
      expectedContexts.should.contain value
      count++
    count.should.equal expectedContexts.length

  it 'is immutable', ->
    SchemaContext.should.be.frozen
