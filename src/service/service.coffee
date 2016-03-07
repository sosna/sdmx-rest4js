{ServiceType} = require '../../src/service/service-type.coffee'
{isValidEnum, createErrorMessage} = require '../utils/validators.coffee'

defaults =
  api: ServiceType.LATEST

isValidUrl = (url, errors) ->
  valid = url
  if not valid
    errors.push "#{url} is not in a valid url"
  valid

validService = (q) ->
  errors = []
  isValid = isValidUrl(q.url, errors) and
    isValidEnum(q.api, ServiceType, 'versions of the SDMX RESTful API', errors)
  {isValid: isValid, errors: errors}

service = class Service

  defaults: Object.freeze defaults

  @ECB:
    id: 'ECB'
    name: 'European Central Bank'
    api: ServiceType.SDMX_REST_v1_0_2
    url: 'http://sdw-wsrest.ecb.europa.eu/service'

  constructor: (@url) ->

  provider: (@id, @name) ->
    @

  api: (@version) ->
    @

  build: ->
    service =
      id: @id
      name: @name
      url: @url
      api: @version ? defaults.api
    input = validService service
    throw Error createErrorMessage(input.errors, 'service') unless input.isValid
    service

  @from: (opts) ->
    new Service(opts?.url).provider(opts?.id, opts?.name).api(opts.api).build()

exports.Service = service
