should = require('chai').should()
{MetadataReferences} = require('../../src/metadata/metadata-references')

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
    'transformationscheme'
    'rulesetscheme'
    'userdefinedoperatorscheme'
    'customtypescheme'
    'namepersonalisationscheme'
    'namealiasscheme'
    'none'
    'parents'
    'parentsandsiblings'
    'children'
    'descendants'
    'all'
  ]

  it 'contains all the expected references and only those', ->
    count = 0
    for key, value of MetadataReferences
      expectedReferences.should.contain value
      count++
    count.should.equal expectedReferences.length

  it 'is immutable', ->
    MetadataReferences.should.be.frozen
