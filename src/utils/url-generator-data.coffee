{ApiNumber, ApiVersion, getKeyFromVersion} = require '../utils/api-version'
{createEntryPoint, validateDataForV2, parseFlow} = require '../utils/url-generator-common'
{DataDetail} = require '../data/data-detail'

translateDetail = (detail) ->
  if detail == DataDetail.NO_DATA
    "attributes=dataset,series&measures=none"
  else if detail == DataDetail.DATA_ONLY
    "attributes=none&measures=all"
  else if detail == DataDetail.SERIES_KEYS_ONLY
    "attributes=none&measures=none"
  else
    "attributes=dsd&measures=all"

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

createDataQuery = (q, s, a) ->
  if a < ApiNumber.v2_0_0
    createV1DataUrl q, s
  else
    createV2DataUrl q, s

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
 
createShortDataQuery = (q, s, a) ->
  if a < ApiNumber.v2_0_0
    createShortV1Url q, s
  else
    createShortV2Url q, s

checkMultipleItems = (i, s, r, a) ->
  if a < ApiNumber.v1_3_0 and /\+/.test i
    throw Error "Multiple #{r} not allowed in #{s.api}"

handler = class Handler

  handle: (q, s, skip) ->
    api = ApiNumber[getKeyFromVersion(s.api)]
    checkMultipleItems(q.provider, s, 'providers', api)
    if skip
      createShortDataQuery(q, s, api)
    else
      createDataQuery(q, s, api)

exports.DataQueryHandler = handler
