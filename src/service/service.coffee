{ApiVersion} = require '../../src/utils/api-version'
{isValidEnum, createErrorMessage} = require '../utils/validators'

defaults =
  api: ApiVersion.LATEST

isValidUrl = (url, errors) ->
  valid = url
  errors.push "#{url} is not in a valid url" unless valid
  valid

isValidService = (q) ->
  errors = []
  isValid = isValidUrl(q.url, errors) and
    isValidEnum(q.api, ApiVersion, 'versions of the SDMX RESTful API', errors)
  {isValid: isValid, errors: errors}

service = class Service

  @ECB:
    id: 'ECB'
    name: 'European Central Bank'
    api: ApiVersion.SDMX_REST_v1_0_2
    url: 'http://sdw-wsrest.ecb.europa.eu/service'

  @from: (opts) ->
    service =
      id: opts?.id
      name: opts?.name
      url: opts?.url
      api: opts?.api ? defaults.api
    input = isValidService service
    throw Error createErrorMessage(input.errors, 'service') unless input.isValid
    service

exports.Service = service
