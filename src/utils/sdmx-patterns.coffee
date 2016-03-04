NestedNCNameIDType = /// ^
  [A-Za-z]                      # Must begin with a letter
  [A-Za-z0-9_\-]*               # May be followed by letters, numbers, _ or -
  (\.[A-Za-z][A-Za-z0-9_\-]*)*  # May be followed by a dot and other IDs
  $ ///

IDType = /// ^
  [A-Za-z0-9_@$\-]+    # Letters, numbers, _, @, $ or -
  $ ///

VersionType = /// ^
  (                    # Starts the OR clause
  all                  # The string all
  | latest             # Or the string latest
  | [0-9]+(\.[0-9]+)*  # Or a version number (e.g. 1.0)
  )                    # Ends the OR clause
  $ ///

NestedIDType = /// ^
  [A-Za-z0-9_@$\-]+       # Letters, numbers, _, @, $ or -
  (\.[A-Za-z0-9_@$\-]+)*  # Potentially hierarchical (e.g. A.B.C)
  $ ///

exports.NestedNCNameIDType = NestedNCNameIDType
exports.IDType = IDType
exports.VersionType = VersionType
exports.NestedIDType = NestedIDType