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
SdmxPatterns = require './utils/sdmx-patterns'
fetch = require 'isomorphic-fetch'

userAgent = 'sdmx-rest4js (https://github.com/sosna/sdmx-rest4js)'

checkStatus = (query, response) ->
  code  = response?.status
  unless 100 < code < 300 or code is 304 or (code is 404 and query.updatedAfter)
    throw RangeError "Request failed with error code #{code}"

addHeaders = (opts, s, isDataQuery) ->
  opts = opts ? {}
  headers = {}
  headers[key.toLowerCase()] = opts.headers[key] for key of opts.headers
  headers.accept = s.format unless headers.accept if s.format and isDataQuery
  headers['user-agent'] = userAgent unless headers['user-agent']
  opts.headers = headers
  opts

guessService = (u) ->
  s = (Service[k] for own k of Service when u.startsWith Service[k]?.url)
  return s[0] ? {}

#
# Get an SDMX 2.1 RESTful web service against which queries can be executed.
#
# This library offers a few predefined services, which you can access using the
# service identifier.
#
# @example Get a predefined service
#   sdmxrest.getService('ECB')
#
# In case the service to be accessed is not yet predefined, an object with the
# information necessary to create the service can be passed as parameter.
#
# @example Create a service
#   sdmxrest.getService({url: 'http://ws-entry-point'})
#
# The expected properties for the object are:
# - *url* - the entry point of the SDMX 2.1 RESTful web service
# - *api* (optional) - the version of the SDMX 2.1 RESTful API supported by
#   the service. If not supplied, it will default to the most recent version of
#   the SDMX RESTful API (1.1.0 at the moment)
# - *id* (optional) - an identifier for the web service
# - *name* (optional) - a label for the web service
#
# @param [Object|String] input the ID of a predefined service or an object with
#   the information about the service to be instantiated
#
# @throw an error in case a) a string is supplied and it is not the ID of a
# predefined service or b) an object is supplied and it does not contain a
# valid *url* property.
#
getService = (input) ->
  if typeof input is 'string'
    throw ReferenceError "#{input} is not in the list of predefined services" \
      unless Service[input]
    Service[input]
  else if input instanceof Object \
  and Object.prototype.toString.call(input) is '[object Object]'
    Service.from input
  else
    throw TypeError "Invalid type of #{input}. Expected an object or a string"

#
# Get an SDMX 2.1 RESTful data query.
#
# The expected properties (and their default values) are:
# - *flow*: **Mandatory** - the id of the dataflow of the data to be returned
# - *key* (optional) - the key of the data to be returned (default: all)
# - *provider* (optional) - the provider of the data (default: all)
# - *start* (optional) - the start period for which data should be returned
# - *end* (optional) - the end period for which data should be returned
# - *updatedAfter* (optional) - instructs the service to return what has
#   changed since the supplied time stamp.
# - *firstNObs* (optional) - the number of observations to be returned,
#   starting from the first observation
# - *lastNObs* (optional) - the number of observations to be returned,
#   starting from the last observation
# - *obsDimension* (optional) - the ID of the dimension to be attached at the
#   observation level (default TIME_PERIOD).
# - *detail* (optional) - the desired amount of information to be returned
#   (default: full).
# - *history* (optional) - Whether previous versions of the data should be
#   returned (default: false).
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
# - *agency* (optional) - the agency maintaining the metadata to be returned
#   (default: all)
# - *id* (optional) - the id of the metadata to be returned (default: all)
# - *version* (optional) - the version of the metadata to be returned
#   (default: latest)
# - *item* (optional) - for item schemes query, the id of the item to be
#   returned (default: all)
# - *detail* (optional) - the desired amount of information to be returned
#  (default: full)
# - *references* (optional) - whether to return the artefacts referenced by,
#   or that use, the metadata to be returned (default: none)
#
# @example Create a query for all codelists maintained by the ECB
#   sdmxrest.getMetadataQuery({resource: 'codelist', agency: 'ECB'})
#
# @example Create a query for the BOP data structure maintained by the IMF,
#   along with all the codelists and concepts used in the data structure
#   sdmxrest.getMetadataQuery({resource: 'datastructure', agency: 'IMF',
#     id: 'BOP', references: 'descendants'})
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
  throw ReferenceError 'Service is a mandatory parameter' unless service
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
 #    .then(function(data) {console.log(data);})
#     .catch(function(error) {console.log(error);});
#
# @example Executes the supplied query against the supplied service, asking the
#   service to return a compressed SDMX-JSON message.
#   sdmxrest.request({flow: 'EXR', key: 'A.CHF.EUR.SP00.A'}, 'ECB',
#     {headers: {accept: DataFormat.SDMX_JSON, accept-encoding: "gzip"}})
#     .then(function(data) {console.log(data);})
#     .catch(function(error) {console.log(error);});
#
# In case you already have an SDMX 2.1 RESTful query string, you can also use it
# with execute().
#
# @example Fetches the supplied URL
#   sdmxrest.request('http://sdw-wsrest.ecb.europa.eu/service/data/EXR')
 #    .then(function(data) {console.log(data);})
#     .catch(function(error) {console.log(error);});
#
# @example Fetches the supplied URL, asking the service to return a compressed
# SDMX-JSON message
#   sdmxrest.request('http://sdw-wsrest.ecb.europa.eu/service/data/EXR',
#     {headers: {accept: DataFormat.SDMX_JSON, accept-encoding: "gzip"}})
#     .then(function(data) {console.log(data);})
#     .catch(function(error) {console.log(error);});
#
# @param [Object|String] query the query to be executed
# @param [Object|String] service the service against which the query should be
#   executed. This should not be set in case an SDMX 2.1 query string is passed
#   as 1st parameter
# @param [Object] opts additional options for the request. See the whatwg fetch
#   specification for additional information.
#
# @throw an error in case the query and/or the service are not valid.
#
# @see #getDataQuery
# @see #getMetadataQuery
# @see #getService
#
request = (params...) ->
  q = params[0]
  s = if typeof q is 'string' then guessService q else getService params[1]
  u = if typeof q is 'string' then q else getUrl q, s
  o = if typeof q is 'string' then params[1] else params[2]
  isDataQuery = false
  if typeof q is 'string' and q.includes '/data/'
    isDataQuery = true
  else if q.flow
    isDataQuery = true

  requestOptions = addHeaders o, s, isDataQuery
  fetch(u, requestOptions)
    .then((response) ->
      checkStatus q, response
      response.text())
    .then((body) -> body)

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
