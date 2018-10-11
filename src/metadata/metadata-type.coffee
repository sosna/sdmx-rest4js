# Specifies the types of structural metadata defined in SDMX.
itemSchemes = [
  'categoryscheme'
  'conceptscheme'
  'codelist'
  'organisationscheme'
  'agencyscheme'
  'dataproviderscheme'
  'dataconsumerscheme'
  'organisationunitscheme'
  'hierarchicalcodelist'
]

types =
  DATA_STRUCTURE: 'datastructure'
  METADATA_STRUCTURE: 'metadatastructure'
  CATEGORY_SCHEME: 'categoryscheme'
  CONCEPT_SCHEME: 'conceptscheme'
  CODELIST: 'codelist'
  HIERARCHICAL_CODELIST: 'hierarchicalcodelist'
  ORGANISATION_SCHEME: 'organisationscheme'
  AGENCY_SCHEME: 'agencyscheme'
  DATA_PROVIDER_SCHEME: 'dataproviderscheme'
  DATA_CONSUMER_SCHEME: 'dataconsumerscheme'
  ORGANISATION_UNIT_SCHEME: 'organisationunitscheme'
  DATAFLOW: 'dataflow'
  METADATAFLOW: 'metadataflow'
  REPORTING_TAXONOMY: 'reportingtaxonomy'
  PROVISION_AGREEMENT: 'provisionagreement'
  STRUCTURE_SET: 'structureset'
  PROCESS: 'process'
  CATEGORISATION: 'categorisation'
  CONTENT_CONSTRAINT: 'contentconstraint'
  ATTACHMENT_CONSTRAINT: 'attachmentconstraint'
  ACTUAL_CONSTRAINT: 'actualconstraint'
  ALLOWED_CONSTRAINT: 'allowedconstraint'
  STRUCTURE: 'structure'

exports.MetadataType = Object.freeze types
exports.isItemScheme = (type) -> type in itemSchemes
