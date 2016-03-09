{Service} = require './service/service.coffee'
{DataQuery} = require './data/data-query.coffee'
{MetadataQuery} = require './metadata/metadata-query.coffee'
{UrlGenerator} = require './utils/url-generator.coffee'

getService = (id) ->
  if typeof id is 'object'
    return Service.from id
  if typeof id is 'string' and Service[id]
    return Service[id]
  throw Error "Unknown service #{id}"

getDataQuery = (opts) ->
  return DataQuery.from opts

getMetadataQuery = (opts) ->
  return MetadataQuery.from opts

getUrl = (query, service) ->
  return new UrlGenerator().getUrl query, service

exports.getService = getService
exports.getDataQuery = getDataQuery
exports.getMetadataQuery = getMetadataQuery
exports.getUrl = getUrl
