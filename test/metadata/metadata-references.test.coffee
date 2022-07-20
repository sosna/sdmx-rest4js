should = require('chai').should()
{MetadataReferences} = require('../../src/metadata/metadata-references')
{MetadataReferencesExcluded} = require('../../src/metadata/metadata-references')
{MetadataReferencesSpecial} = require('../../src/metadata/metadata-references')

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
    'dataconstraint'
    'metadataconstraint'
    'hierarchy'
    'hierarchyassociation'
    'vtlmappingscheme'
    'valuelist'
    'structuremap'
    'representationmap'
    'conceptschememap'
    'categoryschememap'
    'organisationschememap'
    'reportingtaxonomymap'
    'metadataproviderscheme'
    'metadataprovisionagreement'
    'none'
    'parents'
    'parentsandsiblings'
    'ancestors'
    'children'
    'descendants'
    'all'
  ]

  excluded = [
    'structure'
    'actualconstraint'
    'allowedconstraint'
    '*'
  ]

  special = [
    'none'
    'parents'
    'parentsandsiblings'
    'ancestors'
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

  it 'indicates which references are excluded', ->
    MetadataReferencesExcluded.should.eql excluded
    MetadataReferencesExcluded.should.be.frozen

  it 'indicates which references are the special ones', ->
    MetadataReferencesSpecial.should.be.frozen
    count = 0
    for key, value of MetadataReferencesSpecial
      special.should.contain value
      count++
    count.should.equal special.length

