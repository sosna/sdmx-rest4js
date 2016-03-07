{ReportingPeriodType} = require './sdmx-patterns.coffee'

validEnum = (input, list, name, errors) ->
  found = false
  for key, value of list
    found = true if value is input
  unless found
    errors.push "#{input} is not in the list of supported #{name} \
      (#{value for key, value of list})"
  found

validPattern = (input, regex, name, errors) ->
  valid = input and input.match regex
  unless valid
    errors.push "#{input} is not compliant with the pattern defined for \
    #{name} (#{regex})"
  valid

createErrorMessage = (errors, type) ->
  msg = "Not a valid #{type}: \n"
  msg += "- #{error} \n" for error in errors
  msg

validIso8601 = (input, name, errors) ->
  valid = true
  if isNaN(Date.parse(input))
    errors.push "#{name} must be a valid ISO8601 date"
    valid = false
  valid

validPeriod = (input, name, errors) ->
  valid = validIso8601(input, name, errors) \
    or validPattern(input, ReportingPeriodType, name, errors)
  unless valid
    errors.push "#{name} must be a valid SDMX period or a valid ISO8601 date"
    valid = false
  valid

exports.isValidEnum = validEnum
exports.isValidPattern = validPattern
exports.createErrorMessage = createErrorMessage
exports.isValidDate = validIso8601
exports.isValidPeriod = validPeriod
