{DataQuery} = require './data/data-query'
{DataFormat} = require './data/data-format'
{DataDetail} = require './data/data-detail'
{MetadataQuery} = require './metadata/metadata-query'
{MetadataFormat} = require './metadata/metadata-format'
{MetadataDetail} = require './metadata/metadata-detail'
{MetadataReferences} = require './metadata/metadata-references'
{MetadataType} = require './metadata/metadata-type'
{Service} = require './service/service'
{UrlGenerator} = require './utils/url-generator'
{ApiVersion} = require './utils/api-version'
{SdmxPatterns} = require './utils/sdmx-patterns'

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

module.exports =
  getService: getService
  getDataQuery: getDataQuery
  getMetadataQuery: getMetadataQuery
  getUrl: getUrl
  data:
    DataFormat: DataFormat
    DataDetail: DataDetail
  metadata:
    MetadataFormat: MetadataFormat
    MetadataDetail: MetadataDetail
    MetadataReferences: MetadataReferences
    MetadataType: MetadataType
  utils:
    ApiVersion: ApiVersion
    SdmxPatterns: SdmxPatterns
