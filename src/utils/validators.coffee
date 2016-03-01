validEnum = (input, list, name, errors) ->
  found = false
  for key, value of list
    if value == input then found = true
  if not found
    errors.push """
      #{input} is not in the list of supported #{name} \
      (#{value for key, value of list})
    """
  found

validPattern = (input, regex, name, errors) ->
  valid = input.match regex
  if not valid
    errors.push """
      #{input} is not compliant with the pattern defined for #{name} (#{regex})
    """
  valid

exports.isValidEnum = validEnum
exports.isValidPattern = validPattern
