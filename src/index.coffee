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
fetch = require 'isomorphic-fetch'

checkStatus = (query, response) ->
  code  = response?.status
  unless 100 < code < 300 or code is 304 or (code is 404 and query.updatedAfter)
    throw Error "Request failed with error code #{code}"

#
# Get an SDMX 2.1 RESTful web service against which queries can be executed.
#
# This library offers a few predefined services, which you can access using the
# service identifier.
#
# @example Get a predefined services
#   sdmxrest.getService('ECB')
#
# In case the service to be accessed is not yet predefined, an object with the
# information necessary to create the service can be passed as parameter.
#
# @example Create a service
#   sdmxrest.getService({url: 'http://ws-entry-point'})
#
# The expected properties for the object are:
# - *url*: **Mandatory** - the entry point of the SDMX 2.1 RESTful web service
# - *api*: **Optional** - the version of the SDMX 2.1 RESTful API supported by
#   the service. If not supplied, it will default to the most recent version of
#   the SDMX RESTful API (1.1.0 at the moment)
# - *id*: **Optional** - an identifier for the web service
# - *name*: **Optional** - a label for the web service
#
# @param [Object|String] input the ID of a predefined service or an object with
#   the information about the service to be instantiated
#
# @throw an error in case a) a string is supplied and it is not the ID of a
# predefined service or b) an object is supplied and it does not contain a
# valid *url* property.
#
getService = (input) ->
  if typeof input is 'object'
    return Service.from input
  if typeof input is 'string' and Service[input]
    return Service[input]
  throw Error "Unknown or invalid service #{input}"

#
# Get an SDMX 2.1 RESTful data query.
#
# The expected properties (and their default values) are:
# - *flow*: **Mandatory** - the id of the dataflow of the data to be returned
# - *key*: **Optional** - the key of the data to be returned. Defaults to *all*.
# - *provider*: **Optional** - the provider of the data to be returned.
#   Defaults to *all*.
# - *start*: **Optional** - the start period for which data should be returned
# - *end*: **Optional** - the end period for which data should be returned
# - *updatedAfter*: **Optional** - instructs the service to return what has
#   changed since the supplied time stamp.
# - *firstNObs*: **Optional** - the number of observations to be returned,
#   starting from the first observation
# - *lastNObs*: **Optional** - the number of observations to be returned,
#   starting from the last observation
# - *obsDimension*: **Optional** - the ID of the dimension to be attached at the
#   observation level. Default to *TIME_PERIOD*.
# - *detail*: **Optional** - the desired amount of information to be returned.
#   Defaults to *full*.
# - *history*: **Optional** - Whether previous versions of the data should be
#   returned. Defaults to false.
#
# @example Create a query for all data belonging to the EXR dataflow
#   sdmxrest.getDataQuery({flow: 'EXR'})
#
# @example Create a query for EXR data, matching values A and Q for the 1st
# dimension, any value for the 2nd dimension, EUR, SP00 and A for the 3rd, 4th
# and 5th dimensions respectively
#   sdmxrest.getDataQuery({flow: 'EXR', key: 'A+Q..EUR.SP00.A'})
#
# @example Create a query for the last observation of the EXR data matching the
#  supplied key
#   sdmxrest.getDataQuery({flow: 'EXR', key: 'A.CHF.EUR.SP00.A', lastNObs: 1})
#
# @example Create a query to get what has changed for the matching data since
#   the supplied point in time
#   sdmxrest.getDataQuery({flow: 'EXR', key: 'A.NOK.EUR.SP00.A',
#     updatedAfter: '2016-03-17T14:38:00Z'})
#
# @param [Object] input an object with the desired filters for the query
#
# @throw an error in case a) the mandatory flow is not supplied or b) a value
# not compliant with the SDMX 2.1 RESTful specification is supplied for one of
# the properties.
#
getDataQuery = (input) ->
  return DataQuery.from input

#
# Get an SDMX 2.1 RESTful metadata query.
#
# The expected properties (and their default values) are:
# - *resource*: **Mandatory** - the type of structural metadata to be returned
# - *agency*: **Optional** - the agency maintaining the metadata to be returned.
#   Defaults to *all*.
# - *id*: **Optional** - the id of the metadata to be returned. Defaults to
#   *all*.
# - *version*: **Optional** - the version of the metadata to be returned.
#   Defaults to *latest*.
# - *item*: **Optional** - for item schemes query, the id of the item to be
#   returned. Defaults to *all*.
# - *detail*: **Optional** - the desired amount of information to be returned.
#  Defaults to *full*.
# - *references*: **Optional** - whether to return the artefacts referenced by,
#   or that use, the metadata to be returned. Defaults to *none*.
#
# @example Create a query for all codelists maintained by the ECB
#   sdmxrest.getMetadataQuery({resource: 'codelist', agency: 'ECB'})
#
# @example Create a query for the BOP data structure maintained by the IMF,
#   along with all the codelists and concepts used in the data structure
#   sdmxrest.getMetadataQuery({resource: 'datastructure', agency: 'IMF',
#     references: 'descendants'})
#
# @param [Object] input an object with the desired filters for the query
#
# @throw an error in case a) the mandatory resource is not supplied or
# b) a value not compliant with the SDMX 2.1 RESTful specification is supplied
# for one of the properties.
#
getMetadataQuery = (input) ->
  return MetadataQuery.from input

#
# Get the SDMX 2.1 RESTful URL representing the query to be executed against the
# supplied service.
#
# @example Get the URL representing the query to be executed against the
#   supplied service
#   sdmxrest.getUrl({flow: 'EXR', key: 'A.CHF.EUR.SP00.A'}, 'ECB')
#
# @param [Object] query the query to be executed
# @param [Object|String] service the service against which the query should be
#   executed
#
# @throw an error in case the query and/or the service are not valid.
#
# @see #getDataQuery
# @see #getMetadataQuery
# @see #getService
#
getUrl = (query, service) ->
  # URL generation requires all fields to be set. The 3 next lines are just
  # in case partial objects are passed to the function.
  s = getService service
  throw Error 'Not a valid query' unless query?.flow or query?.resource
  q = if query.flow then getDataQuery query else getMetadataQuery query

  return new UrlGenerator().getUrl q, s

#
# Executes the supplied query against the supplied service and returns a
# Promise.
#
# The returned Promise should be handled using the *then* and *catch* methods
# offered by a Promise.
#
# @example Executes the supplied query against the supplied service
#   sdmxrest.request({flow: 'EXR', key: 'A.CHF.EUR.SP00.A'}, 'ECB')
#
# @example Executes the supplied query against the supplied service, asking the
#   service to return a compressed SDMX-JSON message.
#   sdmxrest.request({flow: 'EXR', key: 'A.CHF.EUR.SP00.A'}, 'ECB',
#     {headers: {accept: DataFormat.SDMX_JSON, accept-encoding: "gzip"}})
#     .then(function(data) {console.log(data);})
#     .catch(function(error) {console.log(error);});
#
# @param [Object] query the query to be executed
# @param [Object|String] service the service against which the query should be
#   executed
# @param [Object] opts additional options for the request. See the whatwg fetch
#   specification for additional information.
#
# @throw an error in case the query and/or the service are not valid.
#
# @see #getDataQuery
# @see #getMetadataQuery
# @see #getService
#
request = (query, service, opts) ->
  url = getUrl query, service
  fetch(url, opts)
    .then((response) ->
      checkStatus query, response
      response.text())
    .then((body) -> body)
    .catch((error) ->
      throw Error "Request failed: #{error}")

module.exports =
  getService: getService
  getDataQuery: getDataQuery
  getMetadataQuery: getMetadataQuery
  getUrl: getUrl
  request: request
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
