{Service} = require './service/service.coffee'
{DataQuery} = require './data/data-query.coffee'
{MetadataQuery} = require './metadata/metadata-query.coffee'
{UrlGenerator} = require './utils/url-generator.coffee'

getService = (input) ->
  if typeof input is 'object'
    return Service.from input
  if typeof input is 'string' and Service[input]
    return Service[input]
  throw Error "Unknown or invalid service #{input}"

getDataQuery = (input) ->
  return DataQuery.from input

getMetadataQuery = (input) ->
  return MetadataQuery.from input

getUrl = (query, service) ->
  # URL generation requires all fields to be set. The 3 next lines are just
  # in case partial objects are passed to the function.
  s = getService service
  throw Error 'Not a valid query' unless query?.flow or query?.resource
  q = if query.flow then getDataQuery query else getMetadataQuery query

  return new UrlGenerator().getUrl q, s

exports.getService = getService
exports.getDataQuery = getDataQuery
exports.getMetadataQuery = getMetadataQuery
exports.getUrl = getUrl
