# Specifies the amount of information to be returned for metadata queries.
details =

  # All available information for all artefacts is returned.
  FULL: 'full'

  # All artefacts are returned as stubs.
  ALL_STUBS: 'allstubs'

  # Referenced artefacts are returned as stubs.
  REFERENCE_STUBS: 'referencestubs'

  # Referenced schemes only include items used by the artefact to be returned.
  REFERENCE_PARTIAL: 'referencepartial'

exports.MetadataDetail = Object.freeze details
