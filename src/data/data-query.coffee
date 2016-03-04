{DataDetail} = require './data-detail.coffee'
{FlowRefType, SeriesKeyType, ProviderRefType, NCNameIDType} =
  require '../utils/sdmx-patterns.coffee'
{isValidEnum, isValidPattern, isValidPeriod, isValidDate, createErrorMessage} =
  require '../utils/validators.coffee'

defaults =
  key: 'all'
  provider: 'all'
  obsDimension: 'TIME_PERIOD'
  detail: DataDetail.FULL
  history: false

isValidHistory = (input, errors) ->
  valid = typeof input is 'boolean'
  if not valid
    errors.push "#{input} is not a valid value for history. Must be true or \
    false"
  valid

isValidNObs = (input, name, errors) ->
  valid = typeof input is 'number' and input > 0
  if not valid
    errors.push "#{input} is not a valid value for #{name}. Must be a positive \
    integer"
  valid

validQuery = (q) ->
  errors = []
  isValid = isValidPattern(q.flow, FlowRefType, 'flows', errors) and
    isValidPattern(q.key, SeriesKeyType, 'series key', errors) and
    isValidPattern(q.provider, ProviderRefType, 'provider', errors) and
    (!q.start or isValidPeriod(q.start, 'start period', errors)) and
    (!q.end or isValidPeriod(q.end, 'end period', errors)) and
    (!q.updatedAfter or isValidDate(q.updatedAfter, 'updatedAfter', errors)) and
    (!q.firstNObs or isValidNObs(q.firstNObs, 'firstNObs', errors)) and
    (!q.lastNObs or isValidNObs(q.lastNObs, 'lastNObs', errors)) and
    isValidPattern(q.obsDimension, NCNameIDType, 'obs dimension', errors) and
    isValidEnum(q.detail, DataDetail, 'details', errors) and
    isValidHistory(q.history, errors)
  {isValid: isValid, errors: errors}

# A query for data, as defined by the SDMX RESTful API.
query = class DataQuery

  defaults: Object.freeze defaults

  constructor: (@flow) ->

  key: (@series) ->
    @

  provider: (@providerRef) ->
    @

  start: (@startPeriod) ->
    @

  end: (@endPeriod) ->
    @

  updatedAfter: (@lastQuery) ->
    @

  firstNObs: (@firstN) ->
    @

  lastNObs: (@lastN) ->
    @

  obsDimension: (@dim) ->
    @

  detail: (@info) ->
    @

  history: (@hist) ->
    @

  build: () ->
    query =
      flow: @flow
      key: @series ? defaults.key
      provider: @providerRef ? defaults.provider
      start: @startPeriod
      end: @endPeriod
      updatedAfter: @lastQuery
      firstNObs: @firstN
      lastNObs: @lastN
      obsDimension: @dim ? defaults.obsDimension
      detail: @info ? defaults.detail
      history: @hist ? defaults.history
    input = validQuery query
    throw Error createErrorMessage(input.errors, 'data query') \
      unless input.isValid
    query

  @from: (options) ->
    new DataQuery(options?.flow).key(options?.key).provider(options?.provider)
      .start(options?.start).end(options?.end)
      .updatedAfter(options?.updatedAfter).firstNObs(options?.firstNObs)
      .lastNObs(options?.lastNObs).obsDimension(options?.obsDimension)
      .detail(options?.detail).history(options?.history).build()

exports.DataQuery = query
