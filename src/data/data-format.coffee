# Specifies the mime types of the various SDMX formats for data.
formats =

  # The SDMX-ML 2.1 Generic data format.
  SDMX_ML_2_1_GENERIC: 'application/vnd.sdmx.genericdata+xml;version=2.1'

  # The SDMX-ML 2.1 Structure Specific data format.
  SDMX_ML_2_1_STRUCTURE_SPECIFIC:
    'application/vnd.sdmx.structurespecificdata+xml;version=2.1'

  # The SDMX-ML 2.1 Generic time series data format.
  SDMX_ML_2_1_GENERIC_TS:
    'application/vnd.sdmx.generictimeseriesdata+xml;version=2.1'

  # The SDMX-ML 2.1 Structure Specific data format.
  SDMX_ML_2_1_STRUCTURE_SPECIFIC_TS:
    'application/vnd.sdmx.structurespecifictimeseriesdata+xml;version=2.1'

  # The SDMX-JSON 1.0.0 data format (Working draft).
  SDMX_JSON_1_0_0_WD: 'application/vnd.sdmx.data+json;version=1.0.0-wd'

  # The SDMX-JSON 1.0.0 data format (Candidate technical specification).
  SDMX_JSON_1_0_0_CTS: 'application/vnd.sdmx.data+json;version=1.0.0-cts'

  # Shortcut for the latest version of SDMX-JSON
  SDMX_JSON: 'application/vnd.sdmx.data+json;version=1.0.0-cts'

  # Shortcut for the latest version of SDMX-ML Generic
  SDMX_ML_GENERIC: 'application/vnd.sdmx.genericdata+xml;version=2.1'

  # Shortcut for the latest version of SDMX-ML Structure Specific
  SDMX_ML_STRUCTURE_SPECIFIC:
    'application/vnd.sdmx.structurespecificdata+xml;version=2.1'

exports.DataFormat = Object.freeze formats
