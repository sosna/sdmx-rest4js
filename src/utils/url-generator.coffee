{Service} = require '../service/service'
{ApiVersion} = require '../utils/api-version'
{DataQuery} = require '../data/data-query'
{MetadataQuery} = require '../metadata/metadata-query'
{isItemScheme} = require '../metadata/metadata-type'

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
  isItemScheme(query.resource))
    url = url + "/#{query.item}"
  url = url + "?detail=#{query.detail}&references=#{query.references}"
  url

generator = class Generator

  getUrl: (@query, service) ->
    @service = service ? ApiVersion.LATEST
    if @query?.flow?
      url = createDataQuery(@query, @service)
    else if @query?.resource?
      url = createMetadataQuery(@query, @service)
    else
      throw TypeError "#{@query} is not a valid SDMX data or metadata query"
    url

exports.UrlGenerator = generator
