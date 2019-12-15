{SchemaContext} = require './schema-context'
{NestedNCNameIDType} = require '../utils/sdmx-patterns'
{isValidEnum, isValidPattern, createErrorMessage} =
  require '../utils/validators'

defaults =
  version: 'latest'
  explicit: false

ValidQuery =
  context: (q, i, e) -> isValidEnum(i, SchemaContext, 'context', e)
  agency: (q, i, e) -> isValidPattern(i, NestedNCNameIDType, 'agency', e)
  id: (q, i, e) -> true
  version: (q, i, e) -> true
  explicit: (q, i, e) -> true
  obsDimension: (q, i, e) -> true

isValidQuery = (query) ->
  errors = []
  isValid = false
  for k, v of query
    isValid = ValidQuery[k](query, v, errors)
    break unless isValid
  {isValid: isValid, errors: errors}

# A query for XML schemas, as defined by the SDMX RESTful API.
query = class SchemaQuery

  @from: (opts) ->
    query =
      context: opts?.context
      agency: opts?.agency
      id: opts?.id
      version: opts?.version ? defaults.version
      explicit: opts?.explicit ? defaults.explicit
      obsDimension: opts?.obsDimension
    input = isValidQuery query
    throw Error createErrorMessage(input.errors, 'schema query') \
      unless input.isValid
    query

exports.SchemaQuery = query
