{Service} = require '../service/service'
{ApiVersion} = require '../utils/api-version'
{DataQuery} = require '../data/data-query'
{MetadataQuery} = require '../metadata/metadata-query'
{isItemScheme} = require '../metadata/metadata-type'
{MetadataDetail} = require '../metadata/metadata-detail'
{MetadataReferences} = require '../metadata/metadata-references'

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

createMetadataQuery = (query, service) ->
  url = createEntryPoint service
  url = url + "#{query.resource}/#{query.agency}/#{query.id}/#{query.version}"
  if (service.api isnt ApiVersion.v1_0_0 and
  service.api isnt ApiVersion.v1_0_1 and
  service.api isnt ApiVersion.v1_0_2 and
  ((query.resource isnt 'hierarchicalcodelist' and
  isItemScheme(query.resource)) or (service.api isnt ApiVersion.v1_1_0 and
  query.resource is 'hierarchicalcodelist')))
    url = url + "/#{query.item}"
  url = url + "?detail=#{query.detail}&references=#{query.references}"
  url

createShortMetadataQuery = (q, s) ->
  u = createEntryPoint s
  u = u + "#{q.resource}"
  if (q.agency isnt "all" or q.id isnt "all" or q.version isnt "latest" or
  q.item isnt "all")
    u = u + "/#{q.agency}"
  if q.id isnt "all" or q.version isnt "latest" or q.item isnt "all"
    u = u + "/#{q.id}"
  if q.version isnt "latest" or q.item isnt "all"
    u = u + "/#{q.version}"
  if (s.api isnt ApiVersion.v1_0_0 and
  s.api isnt ApiVersion.v1_0_1 and
  s.api isnt ApiVersion.v1_0_2 and
  q.item isnt "all" and
  ((q.resource isnt 'hierarchicalcodelist' and
  isItemScheme(q.resource)) or (s.api isnt ApiVersion.v1_1_0 and
  q.resource is 'hierarchicalcodelist')))
    u = u + "/#{q.item}"
  if (q.detail isnt MetadataDetail.FULL or
  q.references isnt MetadataReferences.NONE)
    u = u + "?"
  if q.detail isnt MetadataDetail.FULL
    u = u + "detail=#{q.detail}"
  if (q.detail isnt MetadataDetail.FULL and
  q.references isnt MetadataReferences.NONE)
    u = u + "&"
  if q.references isnt MetadataReferences.NONE
   u = u + "references=#{q.references}"
  u

generator = class Generator

  getUrl: (@query, service, skipDefaults) ->
    @service = service ? ApiVersion.LATEST
    if @query?.flow?
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
