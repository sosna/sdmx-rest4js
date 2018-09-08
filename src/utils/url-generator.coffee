{Service} = require '../service/service'
{ApiVersion} = require '../utils/api-version'
{DataQuery} = require '../data/data-query'
{MetadataQuery} = require '../metadata/metadata-query'
{isItemScheme} = require '../metadata/metadata-type'
{MetadataDetail} = require '../metadata/metadata-detail'
{MetadataReferences} = require '../metadata/metadata-references'

itemAllowed = (resource, api) ->
  api isnt ApiVersion.v1_0_0 and
  api isnt ApiVersion.v1_0_1 and
  api isnt ApiVersion.v1_0_2 and
  ((resource isnt 'hierarchicalcodelist' and isItemScheme(resource)) or
  (api isnt ApiVersion.v1_1_0 and resource is 'hierarchicalcodelist'))

createEntryPoint = (service) ->
  throw ReferenceError "#{service.url} is not a valid service"\
    unless service.url
  url = service.url
  url = url + '/' unless service.url.indexOf('/', service.url.length - 1) > -1
  url

createDataQuery = (query, service) ->
  url = createEntryPoint service
  url = url + "data/#{query.flow}/#{query.key}/#{query.provider}"
  url = url + "?dimensionAtObservation=#{query.obsDimension}"
  url = url + "&detail=#{query.detail}"
  if (service.api isnt ApiVersion.v1_0_0 and
  service.api isnt ApiVersion.v1_0_1 and
  service.api isnt ApiVersion.v1_0_2)
    url = url + "&includeHistory=#{query.history}"
  url = url + "&startPeriod=#{query.start}" if query.start
  url = url + "&endPeriod=#{query.end}" if query.end
  url = url + "&updatedAfter=#{query.updatedAfter}" if query.updatedAfter
  url = url + "&firstNObservations=#{query.firstNObs}" if query.firstNObs
  url = url + "&lastNObservations=#{query.lastNObs}" if query.lastNObs
  url

handleDataPathParams = (q, s) ->
  path = []
  path.push q.provider if q.provider isnt 'all'
  path.push q.key if q.key isnt 'all' or path.length
  if path.length then "/" + path.reverse().join('/') else ""

hasHistory = (q, s) ->
  if (s.api isnt ApiVersion.v1_0_0 and
  s.api isnt ApiVersion.v1_0_1 and
  s.api isnt ApiVersion.v1_0_2 and
  q.history) then true else false

handleDataQueryParams = (q, s) ->
  p = []
  p.push "dimensionAtObservation=#{q.obsDimension}" unless \
    q.obsDimension is 'TIME_PERIOD'
  p.push "detail=#{q.detail}" unless q.detail is 'full'
  p.push "includeHistory=#{q.history}" if hasHistory(q, s)
  p.push "startPeriod=#{q.start}" if q.start
  p.push "endPeriod=#{q.end}" if q.end
  p.push "updatedAfter=#{q.updatedAfter}" if q.updatedAfter
  p.push "firstNObservations=#{q.firstNObs}" if q.firstNObs
  p.push "lastNObservations=#{q.lastNObs}" if q.lastNObs
  if p.length > 0 then u = "?" + p.reduceRight (x, y) -> x + "&" + y else ""

createShortDataQuery = (q, s) ->
  u = createEntryPoint s
  u = u + "data/#{q.flow}"
  u = u + handleDataPathParams(q, s)
  u = u + handleDataQueryParams(q, s)

createMetadataQuery = (query, service) ->
  url = createEntryPoint service
  url = url + "#{query.resource}/#{query.agency}/#{query.id}/#{query.version}"
  if itemAllowed(query.resource, service.api)
    url = url + "/#{query.item}"
  url = url + "?detail=#{query.detail}&references=#{query.references}"
  url

handleMetaPathParams = (q, s, u) ->
  path = []
  if q.item isnt 'all' and itemAllowed(q.resource, s.api) then path.push q.item
  if q.version isnt "latest" or path.length then path.push q.version
  if q.id isnt "all" or path.length then path.push q.id
  if q.agency isnt "all" or path.length then path.push q.agency
  if path.length then u = u + "/" + path.reverse().join('/')
  u

handleMetaQueryParams = (q, u, hd, hr) ->
  if hd or hr then u = u + "?"
  if hd then u = u + "detail=#{q.detail}"
  if hd and hr then u = u + "&"
  if hr then u = u + "references=#{q.references}"
  u

createShortMetadataQuery = (q, s) ->
  u = createEntryPoint s
  u = u + "#{q.resource}"
  u = handleMetaPathParams(q, s, u)
  u = handleMetaQueryParams(q, u, q.detail isnt MetadataDetail.FULL,
    q.references isnt MetadataReferences.NONE)
  u

generator = class Generator

  getUrl: (@query, service, skipDefaults) ->
    @service = service ? ApiVersion.LATEST
    if @query?.flow?
      if skipDefaults
        url = createShortDataQuery(@query, @service)
      else
        url = createDataQuery(@query, @service)
    else if @query?.resource?
      if skipDefaults
        url = createShortMetadataQuery(@query, @service)
      else
        url = createMetadataQuery(@query, @service)
    else
      throw TypeError "#{@query} is not a valid SDMX data or metadata query"
    url

exports.UrlGenerator = generator
