{DataDetail} = require './data-detail'
{FlowRefType, SeriesKeyType, ProviderRefType, NCNameIDType} =
  require '../utils/sdmx-patterns'
{isValidEnum, isValidPattern, isValidPeriod, isValidDate, createErrorMessage} =
  require '../utils/validators'

defaults =
  key: 'all'
  provider: 'all'
  obsDimension: 'TIME_PERIOD'
  detail: DataDetail.FULL
  history: false

isValidHistory = (input, errors) ->
  valid = typeof input is 'boolean'
  errors.push "#{input} is not a valid value for history. Must be true or \
  false" unless valid
  valid

isValidNObs = (input, name, errors) ->
  valid = typeof input is 'number' and input > 0
  errors.push "#{input} is not a valid value for #{name}. Must be a positive \
  integer" unless valid
  valid

isValidQuery = (q) ->
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

toKeyString = (dims) ->
  ((if Array.isArray d then d.join('+') else d ? '') for d in dims).join('.')

# A query for data, as defined by the SDMX RESTful API.
query = class DataQuery

  @from: (opts) ->
    key = opts?.key ? defaults.key
    key = toKeyString key if Array.isArray key
    query =
      flow: opts?.flow
      key: key
      provider: opts?.provider ? defaults.provider
      start: opts?.start
      end: opts?.end
      updatedAfter: opts?.updatedAfter
      firstNObs: opts?.firstNObs
      lastNObs: opts?.lastNObs
      obsDimension: opts?.obsDimension ? defaults.obsDimension
      detail: opts?.detail ? defaults.detail
      history: opts?.history ? defaults.history
    input = isValidQuery query
    throw Error createErrorMessage(input.errors, 'data query') \
      unless input.isValid
    query

exports.DataQuery = query
