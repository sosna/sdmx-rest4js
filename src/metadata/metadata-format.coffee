# Specifies the mime types of the various SDMX formats for structural metadata.
formats =

  # The SDMX-ML 2.1 Structure format.
  SDMX_ML_2_1_STRUCTURE: 'application/vnd.sdmx.structure+xml;version=2.1'

  # The SDMX-JSON 1.0.0 Structure format.
  SDMX_JSON_1_0_0: 'application/vnd.sdmx.structure+json;version=1.0.0'

  # Shortcut for the latest version of SDMX-JSON
  SDMX_JSON: 'application/vnd.sdmx.structure+json;version=1.0.0'

exports.MetadataFormat = Object.freeze formats
