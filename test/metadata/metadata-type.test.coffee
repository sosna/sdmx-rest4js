should = require('chai').should()
{MetadataType} = require('../../src/metadata/metadata-type')

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

  it 'contains all the expected types of metadata and only those', ->
    count = 0
    for key, value of MetadataType
      expectedTypes.should.contain value
      count++
    count.should.equal expectedTypes.length

  it 'is immutable', ->
    MetadataType.should.be.frozen
