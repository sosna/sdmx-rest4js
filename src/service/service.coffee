{ApiVersion} = require '../utils/api-version'
{isValidEnum, createErrorMessage} = require '../utils/validators'
{DataFormat} = require '../data/data-format'
{MetadataFormat} = require '../metadata/metadata-format'

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

createSecureInstance = (service) ->
  secure = {}
  secure[key] = service[key] for key of service
  secure.url = secure.url.replace('http', 'https')
  secure

service = class Service

  @ECB:
    id: 'ECB'
    name: 'European Central Bank'
    api: ApiVersion.v1_0_2
    url: 'http://sdw-wsrest.ecb.europa.eu/service'
    format: DataFormat.SDMX_JSON_1_0_0_WD
    structureFormat: MetadataFormat.SDMX_ML_2_1_STRUCTURE

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

  @WB:
    id: 'WB'
    name: 'World Bank'
    api: ApiVersion.v1_0_2
    url: 'http://wits.worldbank.org/API/V1/SDMX/V21/rest'

  @ECB_S: createSecureInstance @ECB
  @SDMXGR_S: createSecureInstance @SDMXGR
  @OECD_S: createSecureInstance @OECD

  @from: (opts) ->
    service =
      id: opts?.id
      name: opts?.name
      url: opts?.url
      api: opts?.api ? defaults.api
      format: opts?.format
      structureFormat: opts?.structureFormat
    input = isValidService service
    throw Error createErrorMessage(input.errors, 'service') unless input.isValid
    service

services = [
  service.ECB_S
  service.SDMXGR_S
  service.EUROSTAT
  service.OECD_S
  service.WB
]

exports.Service = service
exports.services = services
