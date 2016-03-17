# sdmx-rest4js [![Build Status](https://travis-ci.org/sosna/sdmx-rest4js.svg?branch=master)](https://travis-ci.org/sosna/sdmx-rest4js) [![codecov.io](https://codecov.io/github/sosna/sdmx-rest4js/coverage.svg?branch=master)](https://codecov.io/github/sosna/sdmx-rest4js?branch=master) [![Dependencies](https://david-dm.org/sosna/sdmx-rest4js.svg)](https://david-dm.org/sosna/sdmx-rest4js) [![ISC license](https://img.shields.io/badge/license-ISC%20license-brightgreen.svg)](https://en.wikipedia.org/wiki/ISC_license) [![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

This library allows to easily work with the [SDMX RESTful API](https://github.com/sdmx-twg/sdmx-rest) from a JavaScript application.

In a nutshell, it allows you to easily:
- Create data and metadata queries, using the `getDataQuery` and `getMetadataQuery` functions;
- Get instances of SDMX RESTful web services against which queries can be executed, using the `getService` function;
- Execute a query against a web service and get the matching data or metadata, using the `request` function;
- Build SDMX RESTful URLs that represent queries to be executed against SDMX RESTful web services, using the `getUrl` function. This is handy, in case you want to execute the query using, say, jQuery;

The example below shows how a query can be executed against a predefined service using the `request` function.

```JavaScript
var sdmxrest = require('sdmx-rest');

var query = {flow: 'EXR', key: 'A.CHF.EUR.SP00.A'}

sdmxrest.request(query, 'ECB')
  .then(function(data) {console.log(data);})
  .catch(function(error){console.log("something went wrong: " + error);});
```

For detailed documentation about the API, please check the [Wiki](https://github.com/sosna/sdmx-rest4js/wiki).
