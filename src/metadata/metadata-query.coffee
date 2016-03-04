{MetadataDetail} = require './metadata-detail.coffee'
{MetadataReferences} = require './metadata-references.coffee'
{MetadataType, isItemScheme} = require './metadata-type.coffee'
{NestedNCNameIDType, IDType, VersionType, NestedIDType} =
  require '../utils/sdmx-patterns.coffee'
{isValidEnum, isValidPattern, createErrorMessage} =
  require '../utils/validators.coffee'

defaults =
  agency: 'all'
  id: 'all'
  version: 'latest'
  detail: MetadataDetail.FULL
  references: MetadataReferences.NONE
  item: 'all'

canHaveItem = (query, errors) ->
  allowed = query.item is 'all' or isItemScheme query.resource
  if not allowed
    errors.push "#{query.resource} is not an item scheme and therefore it is \
    not possible to query by item"
  allowed

validQuery = (query) ->
  errors = []
  isValid = isValidEnum(query.resource, MetadataType, 'resources', errors) and
    isValidPattern(query.agency, NestedNCNameIDType, 'agencies', errors) and
    isValidPattern(query.id, IDType, 'resource ids', errors) and
    isValidPattern(query.version, VersionType, 'versions', errors) and
    isValidPattern(query.item, NestedIDType, 'items', errors) and
    canHaveItem(query, errors) and
    isValidEnum(query.detail, MetadataDetail, 'details', errors) and
    isValidEnum(query.references, MetadataReferences, 'references', errors)
  {isValid: isValid, errors: errors}

# A query for structural metadata, as defined by the SDMX RESTful API.
query = class MetadataQuery

  defaults: Object.freeze defaults

  constructor: (@resource) ->

  agency: (@agencyId) ->
    @

  id: (@artefactId) ->
    @

  version: (@ver) ->
    @

  item: (@itemId) ->
    @

  detail: (@info) ->
    @

  references: (@refs) ->
    @

  build: () ->
    query =
      resource: @resource
      agency: @agencyId ? defaults.agency
      id: @artefactId ? defaults.id
      version: @ver ? defaults.version
      detail: @info ? defaults.detail
      references: @refs ? defaults.references
      item: @itemId ? defaults.item
    input = validQuery query
    throw Error createErrorMessage(input.errors, 'metadata query') \
      unless input.isValid
    query

  @from: (options) ->
    new MetadataQuery(options?.resource).agency(options?.agency)
    .id(options?.id).version(options?.version).detail(options?.detail)
    .references(options?.references).build()

exports.MetadataQuery = query
