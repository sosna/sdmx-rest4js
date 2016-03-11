{DataQuery} = require './data/data-query.coffee'
{DataFormat} = require './data/data-format.coffee'
{DataDetail} = require './data/data-detail.coffee'
{MetadataQuery} = require './metadata/metadata-query.coffee'
{MetadataFormat} = require './metadata/metadata-format.coffee'
{MetadataDetail} = require './metadata/metadata-detail.coffee'
{MetadataReferences} = require './metadata/metadata-references.coffee'
{MetadataType} = require './metadata/metadata-type.coffee'
{Service} = require './service/service.coffee'
{UrlGenerator} = require './utils/url-generator.coffee'
{ApiVersion} = require './utils/api-version.coffee'
{SdmxPatterns} = require './utils/sdmx-patterns.coffee'

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
    DataQuery: DataQuery
    DataFormat: DataFormat
    DataDetail: DataDetail
  metadata:
    MetadataQuery: MetadataQuery
    MetadataFormat: MetadataFormat
    MetadataDetail: MetadataDetail
    MetadataReferences: MetadataReferences
    MetadataType: MetadataType
  service:
    Service: Service
  utils:
    ApiVersion: ApiVersion
    SdmxPatterns: SdmxPatterns
