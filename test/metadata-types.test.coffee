should = require('chai').should()
assert = require('chai').assert
{MetadataType} = require('../src/metadata-types.coffee')

describe 'Metadata types', ->

  expectedTypes = [
    'datastructure'
    'metadatastructure'
    'categoryscheme'
    'conceptscheme'
    'codelist'
    'hierarchicalcodelist'
    'organisationscheme'
    'agencyscheme'
    'dataproviderscheme'
    'dataconsumerscheme'
    'organisationunitscheme'
    'dataflow'
    'metadataflow'
    'reportingtaxonomy'
    'provisionagreement'
    'structureset'
    'process'
    'categorisation'
    'contentconstraint'
    'attachmentconstraint'
    'structure'
  ]

  it 'should contain all expected types of metadata and only those', ->
    count = 0
    for key, value of MetadataType
      expectedTypes.should.contain value
      count++
    count.should.equal expectedTypes.length

  it 'should be immutable', ->
    MetadataType.should.be.frozen
