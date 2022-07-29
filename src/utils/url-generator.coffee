{ApiVersion} = require '../utils/api-version'
{AvailabilityQueryHandler} = require '../utils/url-generator-availability'
{SchemaQueryHandler} = require '../utils/url-generator-schema'
{DataQueryHandler} = require '../utils/url-generator-data'
{MetadataQueryHandler} = require '../utils/url-generator-metadata'

generator = class Generator

  getUrl: (@query, service, skipDefaults) ->
    @service = service ? ApiVersion.LATEST
    if @query?.mode?
      new AvailabilityQueryHandler().handle(@query, @service, skipDefaults)
    else if @query?.flow?
      new DataQueryHandler().handle(@query, @service, skipDefaults)
    else if @query?.resource?
      new MetadataQueryHandler().handle(@query, @service, skipDefaults)
    else if @query?.context?
      new SchemaQueryHandler().handle(@query, @service, skipDefaults)
    else
      throw TypeError "#{@query} is not a valid SDMX data, metadata or \
      availability query"

exports.UrlGenerator = generator
