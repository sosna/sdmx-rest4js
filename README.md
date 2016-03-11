# sdmx-rest.js

This library allows to easily work with the [SDMX RESTful API](https://github.com/sdmx-twg/sdmx-rest) from a JavaScript application.

In a nutshell, it allows you to easily:
- Create data and metadata queries;
- Access SDMX RESTful web services;
- Build SDMX RESTful URLs that represent queries to be executed against SDMX RESTful web services.

The example below shows how an SDMX RESTful URL can be build using the `getUrl` function.

```JavaScript
var sdmxrest = require("sdmx-rest");
var url = sdmxrest.getUrl({flow: "EXR"}, "ECB");
```

For detailed documentation about the API, please check the [Wiki](https://github.com/sosna/sdmx-rest4js/wiki).
