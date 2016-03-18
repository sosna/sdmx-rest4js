{ApiVersion} = require '../utils/api-version'
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
    api: ApiVersion.v1_0_2
    url: 'http://sdw-wsrest.ecb.europa.eu/service'

  @SDMXGR:
    id: 'SDMXGR'
    name: 'SDMX Global Registry'
    api: ApiVersion.v1_1_0
    url: 'http://registry.sdmx.org/FusionRegistry/ws/rest'

  @EUROSTAT:
    id: 'EUROSTAT'
    name: 'Eurostat'
    api: ApiVersion.v1_0_2
    url: 'http://www.ec.europa.eu/eurostat/SDMX/diss-web/rest'

  @OECD:
    id: 'OECD'
    name: 'Organisation for Economic Co-operation and Development'
    api: ApiVersion.v1_0_2
    url: 'http://stats.oecd.org/SDMX-JSON'

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
