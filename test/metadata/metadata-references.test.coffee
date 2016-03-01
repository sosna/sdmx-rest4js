should = require('chai').should()
{MetadataReferences} = require('../../src/metadata/metadata-references.coffee')

describe 'Metadata references', ->

  expectedReferences = [
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
    'none'
    'parents'
    'parentsandsiblings'
    'children'
    'descendants'
    'all'
  ]

  it 'should contain all expected references and only those', ->
    count = 0
    for key, value of MetadataReferences
      expectedReferences.should.contain value
      count++
    count.should.equal expectedReferences.length

  it 'should be immutable', ->
    MetadataReferences.should.be.frozen
