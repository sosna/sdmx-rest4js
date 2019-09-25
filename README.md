# sdmx-rest4js
[![Build Status](https://travis-ci.org/sosna/sdmx-rest4js.svg?branch=master)](https://travis-ci.org/sosna/sdmx-rest4js) [![codecov.io](https://codecov.io/github/sosna/sdmx-rest4js/coverage.svg?branch=master)](https://codecov.io/github/sosna/sdmx-rest4js?branch=master) [![Codacy Grade](https://api.codacy.com/project/badge/Grade/7adaf82b611d478882ad1471f02b4314)](https://www.codacy.com/project/sosna/sdmx-rest4js/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=sosna/sdmx-rest4js&amp;utm_campaign=Badge_Grade_Dashboard) [![Known Vulnerabilities](https://snyk.io/test/github/sosna/sdmx-rest4js/badge.svg?targetFile=package.json)](https://snyk.io/test/github/sosna/sdmx-rest4js?targetFile=package.json)  [![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release) [![current version](https://img.shields.io/npm/v/sdmx-rest.svg)](https://www.npmjs.com/package/sdmx-rest) [![Mentioned in Awesome Official Statistics ](https://awesome.re/mentioned-badge.svg)](http://www.awesomeofficialstatistics.org)


This library allows to easily create and execute [SDMX REST queries](https://github.com/sdmx-twg/sdmx-rest) from a JavaScript client application.

In a nutshell, it allows you to:
- Create [data](https://github.com/sosna/sdmx-rest4js/wiki/Data-queries), [metadata](https://github.com/sosna/sdmx-rest4js/wiki/Metadata-queries) and [data availability queries](https://github.com/sosna/sdmx-rest4js/wiki/Other-queries), using the `getDataQuery`, `getMetadataQuery`, `getAvailabilityQuery` functions;
- Get instances of [SDMX RESTful web services](https://github.com/sosna/sdmx-rest4js/wiki/Services) against which queries can be executed, using the `getService` function;
- [Execute a query](https://github.com/sosna/sdmx-rest4js/wiki/Running-queries) against a web service and get the matching data or metadata, using the `request` function;
- Build [SDMX RESTful URLs](https://github.com/sosna/sdmx-rest4js/wiki/URLs) that represent queries to be executed against SDMX RESTful web services, using the `getUrl` function. This is handy, in case you want to execute the query using, say, jQuery;

The example below shows how a query can be executed against a predefined service using the `request` function.

```JavaScript
var sdmxrest = require('sdmx-rest');

var query = {flow: 'EXR', key: 'A.CHF.EUR.SP00.A'};

sdmxrest.request(query, 'ECB')
  .then(function(data) {console.log(data)})
  .catch(function(error){console.log("something went wrong: " + error)});
```

For detailed documentation about the API (and more examples), please check the [Wiki](https://github.com/sosna/sdmx-rest4js/wiki).
