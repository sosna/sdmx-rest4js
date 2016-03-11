# Specifies the amount of information to be returned for metadata queries.
details =

  # All available information for all artefacts will be returned.
  FULL: 'full'

  # All artefacts will be returned as stubs.
  ALL_STUBS: 'allstubs'

  # The referenced artefacts will be returned as stubs.
  REFERENCE_STUBS: 'referencestubs'

exports.MetadataDetail = Object.freeze details
