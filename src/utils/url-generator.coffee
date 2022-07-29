{ApiVersion} = require '../utils/api-version'
{ApiResources} = require '../utils/api-version'
{isItemScheme} = require '../metadata/metadata-type'
{DataDetail} = require '../data/data-detail'
{MetadataDetail} = require '../metadata/metadata-detail'
{MetadataReferences} = require '../metadata/metadata-references'
{MetadataReferencesExcluded} = require '../metadata/metadata-references'
{MetadataReferencesSpecial} = require '../metadata/metadata-references'
{VersionNumber} = require '../utils/sdmx-patterns'
{AvailabilityQueryHandler} = require '../utils/url-generator-availability'
{SchemaQueryHandler} = require '../utils/url-generator-schema'
{DataQueryHandler} = require '../utils/url-generator-data'

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

handleMetadataQuery = (qry, srv, skip) ->
  checkApiVersion(qry, srv)
  checkDetail(qry, srv)
  checkResources(qry, srv)
  checkReferences(qry, srv) if qry.references
  if skip
    createShortMetadataQuery(qry, srv)
  else
    createMetadataQuery(qry, srv)

generator = class Generator

  getUrl: (@query, service, skipDefaults) ->
    @service = service ? ApiVersion.LATEST
    if @query?.mode?
      new AvailabilityQueryHandler().handle(@query, @service, skipDefaults)
    else if @query?.flow?
      new DataQueryHandler().handle(@query, @service, skipDefaults)
    else if @query?.resource?
      handleMetadataQuery(@query, @service, skipDefaults)
    else if @query?.context?
      new SchemaQueryHandler().handle(@query, @service, skipDefaults)
    else
      throw TypeError "#{@query} is not a valid SDMX data, metadata or \
      availability query"

exports.UrlGenerator = generator
