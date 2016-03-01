{MetadataDetail} = require './metadata-detail.coffee'
{MetadataReferences} = require './metadata-references.coffee'
{MetadataType} = require './metadata-types.coffee'
{NestedNCNameIDType, IDType, VersionType} = require './sdmx-patterns.coffee'

defaults =
  agencyID: 'all'
  resourceID: 'all'
  version: 'latest'
  detail: MetadataDetail.FULL
  references: MetadataReferences.NONE

validEnum = (input, list, name, errors) ->
  found = false
  for key, value of list
    if value == input then found = true
  if not found
    errors.push """
      #{input} is not in the list of supported #{name} \
      (#{value for key, value of list})
    """
  found

validPattern = (input, regex, name, errors) ->
  valid = input.match regex
  if not valid
    errors.push """
      #{input} is not compliant with the pattern defined for #{name} (#{regex})
    """
  valid

validQuery = (query) ->
  errors = []
  isValid = validEnum(query.resource, MetadataType, 'resources', errors) and
    validPattern(query.agencyID, NestedNCNameIDType, 'agencies', errors) and
    validPattern(query.resourceID, IDType, 'resource ids', errors) and
    validPattern(query.version, VersionType, 'versions', errors) and
    validEnum(query.detail, MetadataDetail, 'details', errors) and
    validEnum(query.references, MetadataReferences, 'references', errors)
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
