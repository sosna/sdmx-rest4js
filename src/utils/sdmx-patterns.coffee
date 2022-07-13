NCNameIDType = ///
  [A-Za-z]                     # Must begin with a letter
  [A-Za-z0-9_-]*               # May be followed by letters, numbers, _ or -
  ///

NCNameIDTypeAlone = /// ^
  #{NCNameIDType.source}
  $ ///

NestedNCNameIDType = ///
  #{NCNameIDType.source}      # An ID
  (
    \.                        # May be followed by a dot and other IDs
    #{NCNameIDType.source}
  )*
  ///

NestedNCNameIDTypeAlone = /// ^
  #{NestedNCNameIDType.source}
  $ ///

IDType = ///
  [A-Za-z0-9_@$-]+    # Letters, numbers, _, @, $ or -
  ///

IDTypeAlone = /// ^
  #{IDType.source}
  $ ///

VersionNumber = ///
  [0-9]+(\.[0-9]+)*   # A version number (e.g. 1.0)
  ///

SemVer = ///
  \+                           # Latest stable
  |~                           # Latest (un)stable
  |(0|[1-9]\d*[\+~]?|[\+~]?)   # Major part
  \.(0|[1-9]\d*[\+~]?|[\+~]?)  # Minor part
  \.?(0|[1-9]\d*[\+~]?|[\+~]?) # Patch part
  (?:-((?:0|[1-9]\d*
  |\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*
  |\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?
  (?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?
  ///

VersionType = ///
  (                           # Starts the OR clause
  all                         # The string all
  | latest                    # Or the string latest
  | #{VersionNumber.source}   # Or a version number
  )                           # Ends the OR clause
  ///

SingleVersionType = ///
  (                           # Starts the OR clause
  latest                      # the string latest
  | #{VersionNumber.source}   # Or a version number
  | #{SemVer.source}          # Or semver
  )                           # Ends the OR clause
  ///

SingleVersionTypeAlone = /// ^
  #{SingleVersionType.source}
  $ ///

VersionNumberAlone = /// ^
  #{VersionNumber.source}
  $ ///

VersionTypeAlone = /// ^
  #{VersionType.source}
  $ ///

NestedIDType = ///
  [A-Za-z0-9_@$-]+       # Letters, numbers, _, @, $ or -
  (\.[A-Za-z0-9_@$-]+)*  # Potentially hierarchical (e.g. A.B.C)
  ///

NestedIDTypeAlone = /// ^
  #{NestedIDType.source}
  $ ///

SeriesKeyType = /// ^
  (#{IDType.source}([+]#{IDType.source})*)? # One or more dimension values
                                            # separated by a +
  (
    [.]                                        # Potentially followed by a dot
    (#{IDType.source}([+]#{IDType.source})*)?  # and repeating above pattern
  )*
  $ ///

FlowRefType = /// ^
  (
  #{IDType.source}
  | (
    #{NestedNCNameIDType.source}
    ,#{IDType.source}
    (,(latest | (#{VersionNumber.source})))?
    )
  )
  $ ///

ProviderRefType = ///
  (#{NestedNCNameIDType.source},)? # May start with the agency owning the scheme
  #{IDType.source}                 # The id of the provider
  ///

MultipleProviderRefType = /// ^
  (#{ProviderRefType.source}([+]#{ProviderRefType.source})*)
  $///

MultipleAgenciesRefType = /// ^
  (#{NestedNCNameIDType.source}([+]#{NestedNCNameIDType.source})*)
  $///

MultipleIDType = /// ^
  #{IDType.source}([+]#{IDType.source})*
  $///

MultipleNestedIDType = /// ^
  #{NestedIDType.source}([+]#{NestedIDType.source})*
  $///

MultipleVersionsType = /// ^
  #{VersionType.source}([+]#{VersionType.source})*
  $///

ReportingPeriodType = /// ^
  \d{4}-([ASTQ]\d{1}|[MW]\d{2}|[D]\d{3})
  $ ///

exports.NCNameIDType = NCNameIDTypeAlone
exports.NestedNCNameIDType = NestedNCNameIDTypeAlone
exports.IDType = IDTypeAlone
exports.VersionType = VersionTypeAlone
exports.SingleVersionType = SingleVersionTypeAlone
exports.VersionNumber = VersionNumberAlone
exports.NestedIDType = NestedIDTypeAlone
exports.FlowRefType = FlowRefType
exports.ProviderRefType = ProviderRefType
exports.MultipleProviderRefType = MultipleProviderRefType
exports.AgenciesRefType = MultipleAgenciesRefType
exports.ReportingPeriodType = ReportingPeriodType
exports.SeriesKeyType = SeriesKeyType
exports.MultipleIDType = MultipleIDType
exports.MultipleVersionsType = MultipleVersionsType
exports.MultipleNestedIDType = MultipleNestedIDType
