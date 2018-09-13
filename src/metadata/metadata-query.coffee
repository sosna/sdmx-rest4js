{MetadataDetail} = require './metadata-detail'
{MetadataReferences} = require './metadata-references'
{MetadataType, isItemScheme} = require './metadata-type'
{AgenciesRefType, IDType, VersionType, NestedIDType} =
  require '../utils/sdmx-patterns'
{isValidEnum, isValidPattern, createErrorMessage} =
  require '../utils/validators'

defaults =
  agency: 'all'
  id: 'all'
  version: 'latest'
  detail: MetadataDetail.FULL
  references: MetadataReferences.NONE
  item: 'all'

canHaveItem = (query, errors) ->
  allowed = query.item is 'all' or isItemScheme query.resource
  errors.push "#{query.resource} is not an item scheme and therefore it is \
  not possible to query by item" unless allowed
  allowed

validQuery = (query) ->
  errors = []
  isValid = isValidEnum(query.resource, MetadataType, 'resources', errors) and
    isValidPattern(query.agency, AgenciesRefType, 'agencies', errors) and
    isValidPattern(query.id, IDType, 'resource ids', errors) and
    isValidPattern(query.version, VersionType, 'versions', errors) and
    isValidPattern(query.item, NestedIDType, 'items', errors) and
    canHaveItem(query, errors) and
    isValidEnum(query.detail, MetadataDetail, 'details', errors) and
    isValidEnum(query.references, MetadataReferences, 'references', errors)
  {isValid: isValid, errors: errors}

toAgencyString = (p) -> p.join('+')

# A query for structural metadata, as defined by the SDMX RESTful API.
query = class MetadataQuery

  @from: (opts) ->
    a = opts?.agency ? defaults.agency
    a = toAgencyString a if Array.isArray a
    query =
      resource: opts?.resource
      agency: a
      id: opts?.id ? defaults.id
      version: opts?.version ? defaults.version
      detail: opts?.detail ? defaults.detail
      references: opts?.references ? defaults.references
      item: opts?.item ? defaults.item
    input = validQuery query
    throw Error createErrorMessage(input.errors, 'metadata query') \
      unless input.isValid
    query

exports.MetadataQuery = query
