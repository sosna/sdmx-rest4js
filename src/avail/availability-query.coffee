{AvailabilityMode} = require './availability-mode'
{AvailabilityReferences} = require './availability-references'
{FlowRefType, SeriesKeyType, ProviderRefType, NestedNCNameIDType} =
  require '../utils/sdmx-patterns'
{isValidEnum, isValidPattern, isValidPeriod, isValidDate, createErrorMessage} =
  require '../utils/validators'

defaults =
  key: 'all'
  provider: 'all'
  component: 'all'
  mode: AvailabilityMode.EXACT
  references: AvailabilityReferences.NONE

isValidQuery = (q) ->
  errors = []
  isValid = isValidPattern(q.flow, FlowRefType, 'flows', errors) and
    isValidPattern(q.key, SeriesKeyType, 'series key', errors) and
    isValidPattern(q.provider, ProviderRefType, 'provider', errors) and
    isValidPattern(q.component, NestedNCNameIDType, 'component', errors) and
    (!q.start or isValidPeriod(q.start, 'start period', errors)) and
    (!q.end or isValidPeriod(q.end, 'end period', errors)) and
    (!q.updatedAfter or isValidDate(q.updatedAfter, 'updatedAfter', errors)) and
    isValidEnum(q.mode, AvailabilityMode, 'mode', errors) and
    isValidEnum(q.references, AvailabilityReferences, 'references', errors)
  {isValid: isValid, errors: errors}

toKeyString = (dims) ->
  ((if Array.isArray d then d.join('+') else d ? '') for d in dims).join('.')

# A query for data availability, as defined by the SDMX RESTful API.
query = class AvailabilityQuery

  @from: (opts) ->
    key = opts?.key ? defaults.key
    key = toKeyString key if Array.isArray key
    query =
      flow: opts?.flow
      key: key
      provider: opts?.provider ? defaults.provider
      component: opts?.component ? defaults.component
      start: opts?.start
      end: opts?.end
      updatedAfter: opts?.updatedAfter
      mode: opts?.mode ? defaults.mode
      references: opts?.references ? defaults.references
    input = isValidQuery query
    throw Error createErrorMessage(input.errors, 'availability query') \
      unless input.isValid
    query

exports.AvailabilityQuery = query
