# Lists the various versions of the SDMX RESTful API.
versions =

  # The initial version of the SDMX RESTFul API, released in April 2011.
  SDMX_REST_v1_0_0: 'sdmx-rest-v1.0.0'

  # The version of the SDMX RESTFul API, released in May 2012.
  SDMX_REST_v1_0_1: 'sdmx-rest-v1.0.1'

  # The initial version of the SDMX RESTFul API, released in April 2013.
  SDMX_REST_v1_0_2: 'sdmx-rest-v1.0.2'

  # The version of the SDMX RESTFul API released in September 2015. It adds
  # the includeHistory query string parameter as well as the possibility to
  # query for items within item schemes.
  SDMX_REST_v1_1_0: 'sdmx-rest-v1.1.0'

  # A shortcut to the most recent version of the SDMX RESTful API
  LATEST: 'sdmx-rest-v1.1.0'

exports.ApiVersion = Object.freeze versions
