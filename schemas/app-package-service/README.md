

# Build Instructions

## Dependencies

The only dependency is the openapi-generator and the python generator (bundled with openapi-generator by default). Install instructions can be found here: https://openapi-generator.tech/docs/installation/


## Configure and Build
Before building update the openapi.cfg with the version of the library to be built.
```
  "packageVersion":"0.2.0"
```

Then run the build command.

```
openapi-generator generate -c openapi.cfg -i app-package.api.yaml
```

***note*** some tooling uses a different cli syntax:

```
openapi-generator-cli
```
