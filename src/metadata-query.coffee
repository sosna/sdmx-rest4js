{MetadataDetail} = require './metadata-detail.coffee'
{MetadataReferences} = require './metadata-references.coffee'
{MetadataType} = require './metadata-types.coffee'
{NestedNCNameIDType, IDType, VersionType} = require './sdmx-patterns.coffee'
{isValidEnum, isValidPattern} = require './validators.coffee'

defaults =
  agencyID: 'all'
  resourceID: 'all'
  version: 'latest'
  detail: MetadataDetail.FULL
  references: MetadataReferences.NONE

validQuery = (query) ->
  errors = []
  isValid = isValidEnum(query.resource, MetadataType, 'resources', errors) and
    isValidPattern(query.agencyID, NestedNCNameIDType, 'agencies', errors) and
    isValidPattern(query.resourceID, IDType, 'resource ids', errors) and
    isValidPattern(query.version, VersionType, 'versions', errors) and
    isValidEnum(query.detail, MetadataDetail, 'details', errors) and
    isValidEnum(query.references, MetadataReferences, 'references', errors)
  return {
    isValid: isValid
    errors: errors
  }

createMessage = (errors) ->
  msg = 'Not a valid metadata query: \n'
  for error in errors
    msg += "- #{error} \n"
  msg

# A query for structural metadata, as defined by the SDMX RESTful API.
query = class MetadataQuery

  defaults: Object.freeze defaults

  constructor: (@res) ->

  agencyID: (@agency) ->
    @

  # Same as above but cover typos.
  agencyId: (@agency) ->
    @

  resourceID: (@id) ->
    @

  # Same as above but cover typos.
  resourceId: (@id) ->
    @

  version: (@ver) ->
    @

  detail: (@info) ->
    @

  references: (@refs) ->
    @

  build: () ->
    query =
      resource: @res
      agencyID: @agency ? defaults.agencyID
      resourceID: @id ? defaults.resourceID
      version: @ver ? defaults.version
      detail: @info ? defaults.detail
      references: @refs ? defaults.references
    input = validQuery query
    throw Error createMessage(input.errors) unless input.isValid
    query.uri = """
    /#{query.resource}/#{query.agencyID}/#{query.resourceID}/#{query.version}\
    ?detail=#{query.detail}&references=#{query.references}
    """
    query

  @from: (options) ->
    new MetadataQuery(options?.resource).agencyID(options?.agencyID)
    .resourceID(options?.resourceID).version(options?.version)
    .detail(options?.detail).references(options?.references).build()

exports.MetadataQuery = query
