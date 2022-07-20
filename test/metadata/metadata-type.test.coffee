should = require('chai').should()
{MetadataType} = require('../../src/metadata/metadata-type')
{isItemScheme} = require('../../src/metadata/metadata-type')

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
    'actualconstraint'
    'allowedconstraint'
    'structure'
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
    '*'
  ]

  it 'contains all the expected types of metadata and only those', ->
    count = 0
    for key, value of MetadataType
      expectedTypes.should.contain value
      count++
    count.should.equal expectedTypes.length

  it 'is immutable', ->
    MetadataType.should.be.frozen

  it 'considers hierarchicalcodelist as item scheme', ->
    isItemScheme('hierarchicalcodelist').should.be.true

  it 'considers reportingtaxonomy as item scheme', ->
    isItemScheme('reportingtaxonomy').should.be.true

  it 'considers transformationscheme as item scheme', ->
    isItemScheme('transformationscheme').should.be.true

  it 'considers rulesetscheme as item scheme', ->
    isItemScheme('rulesetscheme').should.be.true

  it 'considers userdefinedoperatorscheme as item scheme', ->
    isItemScheme('userdefinedoperatorscheme').should.be.true

  it 'considers customtypescheme as item scheme', ->
    isItemScheme('customtypescheme').should.be.true

  it 'considers namepersonalisationscheme as item scheme', ->
    isItemScheme('namepersonalisationscheme').should.be.true

  it 'considers namealiasscheme as item scheme', ->
    isItemScheme('namealiasscheme').should.be.true
