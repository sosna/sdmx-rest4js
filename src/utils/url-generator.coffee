{ApiVersion} = require '../utils/api-version'
{ApiResources} = require '../utils/api-version'
{isItemScheme} = require '../metadata/metadata-type'
{DataDetail} = require '../data/data-detail'
{MetadataDetail} = require '../metadata/metadata-detail'
{MetadataReferences} = require '../metadata/metadata-references'
{MetadataReferencesExcluded} = require '../metadata/metadata-references'
{MetadataReferencesSpecial} = require '../metadata/metadata-references'
{VersionNumber} = require '../utils/sdmx-patterns'

itemAllowed = (resource, api) ->
  api isnt ApiVersion.v1_0_0 and
  api isnt ApiVersion.v1_0_1 and
  api isnt ApiVersion.v1_0_2 and
  ((resource isnt 'hierarchicalcodelist' and isItemScheme(resource)) or
  (api isnt ApiVersion.v1_1_0 and resource is 'hierarchicalcodelist'))

createEntryPoint = (s) ->
  throw ReferenceError "#{s.url} is not a valid service" unless s.url
  url = s.url
  url = s.url + '/' unless s.url.endsWith('/')
  url

createV1DataUrl = (query, service) ->
  url = createEntryPoint service
  url += "data/#{query.flow}/#{query.key}/#{query.provider}?"
  if query.obsDimension
    url += "dimensionAtObservation=#{query.obsDimension}&"
  url += "detail=#{query.detail}"
  if (service.api isnt ApiVersion.v1_0_0 and
  service.api isnt ApiVersion.v1_0_1 and
  service.api isnt ApiVersion.v1_0_2)
    url += "&includeHistory=#{query.history}"
  url += "&startPeriod=#{query.start}" if query.start
  url += "&endPeriod=#{query.end}" if query.end
  url += "&updatedAfter=#{query.updatedAfter}" if query.updatedAfter
  url += "&firstNObservations=#{query.firstNObs}" if query.firstNObs
  url += "&lastNObservations=#{query.lastNObs}" if query.lastNObs
  url

parseFlow = (flow) ->
  parts = flow.split ","
  if parts.length == 1
    ["*", flow, "*"]
  else if parts.length == 2
    parts.concat ["*"]
  else
    parts

translateDetail = (detail) ->
  if detail == DataDetail.NO_DATA
    "attributes=dataset,series&measures=none"
  else if detail == DataDetail.DATA_ONLY
    "attributes=none&measures=all"
  else if detail == DataDetail.SERIES_KEYS_ONLY
    "attributes=none&measures=none"
  else
    "attributes=dsd&measures=all"

validateDataForV2 = (q, s) ->
  if q.provider isnt "all"
    throw Error "provider not allowed in #{s.api}"
  if q.start
    throw Error "start not allowed in #{s.api}"
  if q.end
    throw Error "end not allowed in #{s.api}"
  if q.key.indexOf("\+") > -1
    throw Error "+ not allowed in key in #{s.api}"

createV2DataUrl = (q, s) ->
  validateDataForV2 q, s
  url = createEntryPoint s
  fc = parseFlow q.flow
  url += "data/dataflow/#{fc[0]}/#{fc[1]}/#{fc[2]}/"
  url += if q.key == "all" then "*?" else "#{q.key}?"
  if q.obsDimension
    url += "dimensionAtObservation=#{q.obsDimension}&"
  url += translateDetail q.detail
  url += "&includeHistory=#{q.history}"
  url += "&updatedAfter=#{q.updatedAfter}" if q.updatedAfter
  url += "&firstNObservations=#{q.firstNObs}" if q.firstNObs
  url += "&lastNObservations=#{q.lastNObs}" if q.lastNObs
  url

createDataQuery = (query, service) ->
  if service.api in preSdmx3
    createV1DataUrl query, service
  else
    createV2DataUrl query, service

handleDataPathParams = (q) ->
  path = []
  path.push q.provider unless q.provider is 'all'
  path.push q.key if q.key isnt 'all' or path.length
  if path.length then '/' + path.reverse().join('/') else ''

handleData2PathParams = (q) ->
  path = []
  path.push q.key if q.key isnt 'all' or path.length
  if path.length then '/' + path.reverse().join('/') else ''

hasHistory = (q, s) ->
  if (s.api isnt ApiVersion.v1_0_0 and
  s.api isnt ApiVersion.v1_0_1 and
  s.api isnt ApiVersion.v1_0_2 and
  q.history) then true else false

handleDataQueryParams = (q, s) ->
  p = []
  p.push "dimensionAtObservation=#{q.obsDimension}" if q.obsDimension
  p.push "detail=#{q.detail}" unless q.detail is 'full'
  p.push "includeHistory=#{q.history}" if hasHistory(q, s)
  p.push "startPeriod=#{q.start}" if q.start
  p.push "endPeriod=#{q.end}" if q.end
  p.push "updatedAfter=#{q.updatedAfter}" if q.updatedAfter
  p.push "firstNObservations=#{q.firstNObs}" if q.firstNObs
  p.push "lastNObservations=#{q.lastNObs}" if q.lastNObs
  if p.length > 0 then '?' + p.reduceRight (x, y) -> x + '&' + y else ''

handleData2QueryParams = (q, s) ->
  p = []
  p.push "dimensionAtObservation=#{q.obsDimension}" if q.obsDimension
  p.push "#{translateDetail q.detail}" unless q.detail is 'full'
  p.push "includeHistory=#{q.history}" if hasHistory(q, s)
  p.push "updatedAfter=#{q.updatedAfter}" if q.updatedAfter
  p.push "firstNObservations=#{q.firstNObs}" if q.firstNObs
  p.push "lastNObservations=#{q.lastNObs}" if q.lastNObs
  if p.length > 0 then '?' + p.reduceRight (x, y) -> x + '&' + y else ''

createShortV1Url = (q, s) ->
  u = createEntryPoint s
  u += "data/#{q.flow}"
  u += handleDataPathParams(q)
  u += handleDataQueryParams(q, s)
  u

createShortV2Url = (q, s) ->
  validateDataForV2 q, s
  u = createEntryPoint s
  fc = parseFlow q.flow
  u += "data/dataflow/#{fc[0]}/#{fc[1]}"
  pp = handleData2PathParams(q)
  if fc[2] isnt "*" or pp isnt ''
    u += "/#{fc[2]}"
  u += pp
  u += handleData2QueryParams(q, s)
  u
 
createShortDataQuery = (q, s) ->
  if s.api in preSdmx3
    createShortV1Url q, s
  else
    createShortV2Url q, s

toApiKeywords = (q, s, value, isVersion = false) ->
  v = value
  if s.api is ApiVersion.v2_0_0 and v is "all"
    v = "*"
  else if s.api isnt ApiVersion.v2_0_0 and v is "*"
    v = "all"
  else if s.api is ApiVersion.v2_0_0 and v is "latest"
    v = "~"
  else if s.api is ApiVersion.v2_0_0 and not isVersion and v.indexOf("\+") > -1
    v = v.replace /\+/, ","
  else if s.api isnt ApiVersion.v2_0_0 and v.indexOf(",") > -1
    v = v.replace /,/, "+"
  v

createMetadataQuery = (q, s) ->
  url = createEntryPoint s
  url += "structure/" unless s.api in preSdmx3
  res = toApiKeywords q, s, q.resource
  agency = toApiKeywords q, s, q.agency
  id = toApiKeywords q, s, q.id
  item = toApiKeywords q, s, q.item
  v = if s.api is ApiVersion.v2_0_0 and q.version is "latest"\
  then "~" else q.version
  url += "#{res}/#{agency}/#{id}/#{v}"
  url += "/#{item}" if itemAllowed(q.resource, s.api)
  url += "?detail=#{q.detail}&references=#{q.references}"
  url

handleMetaPathParams = (q, s, u) ->
  path = []
  if q.item isnt 'all' and q.item isnt '*' and itemAllowed(q.resource, s.api)\
  then path.push toApiKeywords q, s, q.item
  if (q.version isnt 'latest' and q.version isnt '~') or path.length\
  then path.push toApiKeywords q, s, q.version, true
  if (q.id isnt 'all' and q.id isnt '*') or path.length
  then path.push toApiKeywords q, s, q.id
  if (q.agency isnt 'all' and q.agency isnt '*') or path.length
  then path.push toApiKeywords q, s, q.agency
  if path.length then u = u + '/' + path.reverse().join('/')
  u

handleMetaQueryParams = (q, u, hd, hr) ->
  if hd or hr then u += '?'
  if hd then u += "detail=#{q.detail}"
  if hd and hr then u += '&'
  if hr then u += "references=#{q.references}"
  u

createShortMetadataQuery = (q, s) ->
  u = createEntryPoint s
  u += "structure/" unless s.api in preSdmx3
  r = toApiKeywords q, s, q.resource
  u += "#{r}"
  u = handleMetaPathParams(q, s, u)
  u = handleMetaQueryParams(
    q, u, q.detail isnt MetadataDetail.FULL,
    q.references isnt MetadataReferences.NONE
  )
  u

createV1AvailUrl = (q, s) ->
  url = createEntryPoint s
  url += 'availableconstraint'
  url += "/#{q.flow}/#{q.key}/#{q.provider}/#{q.component}"
  url += "?mode=#{q.mode}&references=#{q.references}"
  url += "&startPeriod=#{q.start}" if q.start
  url += "&endPeriod=#{q.end}" if q.end
  url += "&updatedAfter=#{q.updatedAfter}" if q.updatedAfter
  url

createV2AvailUrl = (q, s) ->
  validateDataForV2 q, s
  url = createEntryPoint s
  url += 'availableconstraint'
  fc = parseFlow q.flow
  url += "/dataflow/#{fc[0]}/#{fc[1]}/#{fc[2]}/"
  url += if q.key == "all" then "*/" else "#{q.key}/"
  url += if q.component == "all" then "*" else "#{q.component}"
  url += "?mode=#{q.mode}&references=#{q.references}"
  url += "&updatedAfter=#{q.updatedAfter}" if q.updatedAfter
  url

createAvailabilityQuery = (q, s) ->
  if s.api in preSdmx3
    createV1AvailUrl q, s
  else
    createV2AvailUrl q, s
  
handleAvailabilityPathParams = (q) ->
  path = []
  path.push q.component unless q.component is 'all'
  path.push q.provider if q.provider isnt 'all' or path.length
  path.push q.key if q.key isnt 'all' or path.length
  if path.length then '/' + path.reverse().join('/') else ''

handleAvailabilityQueryParams = (q) ->
  p = []
  p.push "updatedAfter=#{q.updatedAfter}" if q.updatedAfter
  p.push "endPeriod=#{q.end}" if q.end
  p.push "startPeriod=#{q.start}" if q.start
  p.push "mode=#{q.mode}" unless q.mode is 'exact'
  p.push "references=#{q.references}" unless q.references is 'none'
  if p.length > 0 then '?' + p.reduceRight (x, y) -> x + '&' + y else ''

handleAvailabilityV2PathParams = (q) ->
  path = []
  path.push q.component unless q.component is 'all'
  k = if q.key is 'all' then '*' else q.key
  path.push k if k isnt '*' or path.length
  if path.length then '/' + path.reverse().join('/') else ''

handleAvailabilityV2QueryParams = (q) ->
  p = []
  p.push "updatedAfter=#{q.updatedAfter}" if q.updatedAfter
  p.push "mode=#{q.mode}" unless q.mode is 'exact'
  p.push "references=#{q.references}" unless q.references is 'none'
  if p.length > 0 then '?' + p.reduceRight (x, y) -> x + '&' + y else ''

createShortV1AvailUrl = (q, s) ->
  u = createEntryPoint s
  u += "availableconstraint/#{q.flow}"
  u += handleAvailabilityPathParams(q)
  u += handleAvailabilityQueryParams(q)
  u

createShortV2AvailUrl = (q, s) ->
  validateDataForV2 q, s
  u = createEntryPoint s
  u += "availableconstraint/dataflow/"
  fc = parseFlow q.flow
  u += "#{fc[0]}/#{fc[1]}"
  pp = handleAvailabilityV2PathParams(q)
  if fc[2] isnt "*" or pp isnt ""
    u += "/#{fc[2]}"
  u += pp
  u += handleAvailabilityV2QueryParams(q)
  u

createShortAvailabilityQuery = (q, s) ->
  if s.api in preSdmx3
    createShortV1AvailUrl q, s
  else
    createShortV2AvailUrl q, s

createSchemaQuery = (q, s) ->
  u = createEntryPoint s
  v = if s.api is ApiVersion.v2_0_0 and q.version is "latest" then "~"\
  else q.version
  u += "schema/#{q.context}/#{q.agency}/#{q.id}/#{v}"
  if s.api is ApiVersion.v2_0_0
    u += "?dimensionAtObservation=#{q.obsDimension}" if q.obsDimension
  else
    u += "?explicitMeasure=#{q.explicit}"
    u += "&dimensionAtObservation=#{q.obsDimension}" if q.obsDimension
  u

handleSchemaQueryParams = (q) ->
  p = []
  p.push "dimensionAtObservation=#{q.obsDimension}" if q.obsDimension
  p.push "explicitMeasure=#{q.explicit}" if q.explicit
  if p.length > 0 then '?' + p.reduceRight (x, y) -> x + '&' + y else ''

createShortSchemaQuery = (q, s) ->
  u = createEntryPoint s
  u += "schema/#{q.context}/#{q.agency}/#{q.id}"
  u += "/#{q.version}" unless q.version is 'latest' or q.version is '~'
  u += handleSchemaQueryParams(q)
  u

excluded = [
  ApiVersion.v1_0_0
  ApiVersion.v1_0_1
  ApiVersion.v1_0_2
  ApiVersion.v1_1_0
  ApiVersion.v1_2_0
]

preSdmx3 = ([
  ApiVersion.v1_3_0
  ApiVersion.v1_4_0
  ApiVersion.v1_5_0
].concat excluded)

checkMultipleItems = (i, s, r) ->
  if s.api in excluded and /\+/.test i
    throw Error "Multiple #{r} not allowed in #{s.api}"

checkApiVersion = (q, s) ->
  checkMultipleItems q.agency, s, 'agencies'
  checkMultipleItems q.id, s, 'IDs'
  checkMultipleItems q.version, s, 'versions'
  checkMultipleItems q.item, s, 'items'
  checkMultipleVersions q, s

checkDetail = (q, s) ->
  if (s.api in excluded and (q.detail is 'referencepartial' or
  q.detail is 'allcompletestubs' or q.detail is 'referencecompletestubs'))
    throw Error "#{q.detail} not allowed in #{s.api}"

  if (s.api in preSdmx3 and q.detail is 'raw')
    throw Error "raw not allowed in #{s.api}"

checkResource = (q, s, r) ->
  if s and s.api
    api = s.api.replace /\./g, '_'
    throw Error "#{r} not allowed in #{s.api}" unless r in ApiResources[api] \
    or (s.api is ApiVersion.v2_0_0  and r is "*")

checkResources = (q, s) ->
  r = q.resource
  if s.api in preSdmx3
    checkResource q, s, r
  else if r.indexOf("\+") > -1
    for i in r.split "+"
      checkResource q, s, i
  else if r.indexOf(",") > -1
    for i in r.split ","
      checkResource q, s, i
  else
    checkResource q, s, r

checkReferences = (q, s) ->
  if s and s.api
    api = s.api.replace /\./g, '_'
    throw Error "#{q.references} not allowed as reference in #{s.api}" \
      unless (q.references in ApiResources[api] or \
              q.references in Object.values MetadataReferencesSpecial) and \
              q.references not in MetadataReferencesExcluded
  
  if (s.api in preSdmx3 and q.references is 'ancestors')
    throw Error "ancestors not allowed as reference in #{s.api}"
  

checkContext = (q, s) ->
  if s and s.api
    api = s.api.replace /\./g, '_'
    throw Error "#{q.context} not allowed in #{s.api}" \
      unless q.context in ApiResources[api]

checkExplicit = (q, s) ->
  if q.explicit and s and s.api and s.api is ApiVersion.v2_0_0
    throw Error "explicit parameter not allowed in #{s.api}"

checkVersion = (q, s) ->
  v = q.version
  if s and s.api and s.api isnt ApiVersion.v2_0_0
    throw Error "Semantic versioning not allowed in #{s.api}" \
      unless v is 'latest' or v.match VersionNumber

checkVersionWithAll = (q, s, v) ->
  if s and s.api and s.api isnt ApiVersion.v2_0_0
    throw Error "Semantic versioning not allowed in #{s.api}" \
      unless v is 'latest' or v is 'all' or v.match VersionNumber

checkMultipleVersions = (q, s) ->
  v = q.version
  if v.indexOf("\+") > -1
    for i in v.split "+"
      checkVersionWithAll q, s, i
  else if v.indexOf(",") > -1
    for i in v.split ","
      checkVersionWithAll q, s, i
  else
    checkVersionWithAll q, s, v

handleAvailabilityQuery = (qry, srv, skip) ->
  if srv.api in excluded
    throw Error "Availability query not supported in #{srv.api}"
  else if skip
    createShortAvailabilityQuery(qry, srv)
  else
    createAvailabilityQuery(qry, srv)

handleDataQuery = (qry, srv, skip) ->
  checkMultipleItems(qry.provider, srv, 'providers')
  if skip
    createShortDataQuery(qry, srv)
  else
    createDataQuery(qry, srv)

handleMetadataQuery = (qry, srv, skip) ->
  checkApiVersion(qry, srv)
  checkDetail(qry, srv)
  checkResources(qry, srv)
  checkReferences(qry, srv) if qry.references
  if skip
    createShortMetadataQuery(qry, srv)
  else
    createMetadataQuery(qry, srv)

handleSchemaQuery = (qry, srv, skip) ->
  checkContext(qry, srv)
  checkExplicit(qry, srv)
  checkVersion(qry, srv)
  if skip
    createShortSchemaQuery(qry, srv)
  else
    createSchemaQuery(qry, srv)

generator = class Generator

  getUrl: (@query, service, skipDefaults) ->
    @service = service ? ApiVersion.LATEST
    if @query?.mode?
      handleAvailabilityQuery(@query, @service, skipDefaults)
    else if @query?.flow?
      handleDataQuery(@query, @service, skipDefaults)
    else if @query?.resource?
      handleMetadataQuery(@query, @service, skipDefaults)
    else if @query?.context?
      handleSchemaQuery(@query, @service, skipDefaults)
    else
      throw TypeError "#{@query} is not a valid SDMX data, metadata or \
      availability query"

exports.UrlGenerator = generator
