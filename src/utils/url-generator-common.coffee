{ApiVersion} = require '../utils/api-version'
{VersionNumber} = require '../utils/sdmx-patterns'

createEntryPoint = (s) ->
  throw ReferenceError "#{s.url} is not a valid service" unless s.url
  url = s.url
  url = s.url + '/' unless s.url.endsWith('/')
  url

parseFlow = (f) ->
  parts = f.split ","
  if parts.length == 1
    ["*", f, "*"]
  else if parts.length == 2
    parts.concat ["*"]
  else
    parts

validateDataForV2 = (q, s) ->
  if q.provider isnt "all"
    throw Error "provider not allowed in #{s.api}"
  if q.start
    throw Error "start not allowed in #{s.api}"
  if q.end
    throw Error "end not allowed in #{s.api}"
  if q.key.indexOf("\+") > -1
    throw Error "+ not allowed in key in #{s.api}"

checkVersion = (q, s) ->
  v = q.version
  if s.api isnt ApiVersion.v2_0_0
    throw Error "Semantic versioning not allowed in #{s.api}" \
      unless v is 'latest' or v.match VersionNumber

exports.createEntryPoint = createEntryPoint
exports.parseFlow = parseFlow
exports.validateDataForV2 = validateDataForV2
exports.checkVersion = checkVersion