# Tool for query auto generation

#### How to run
```
go run cmd/builder/main.go -i ./cmd/builder/example.tf -o ./out.rego
```

Where `-i` - terraform file to parse, `-o` result query.

Please ensure you have downloaded all tool dependencies, to do that please execute:
```
go mod download
go mod vendor
```

### Supported Comment

The tool supports only comments which have Golang struct tag syntax, for example `// Comment:"attribute1,attribute2=value" Comment2`. (note: space is not allowed in comments attributes).
For more example please take a look at the example files.

Supported comment:
* `MissingAttribute`
* `RedundantAttribute`
* `IncorrectValue`
  * `resource` - to target a resource, can be `resource=*`, `resource=['s3_bucket','sqs_queue']`, by default resource from terraform file will be used 
  * `any_key` - allow any element in condition, example `resosource.vars.name -> resource.vars[_]`
  * `upper/lower` - to wrap condition, example `resosource.vars.name -> upper(resource.vars.name)`
  * `regex` - use `re_match` for a condition, should be provided with a regex pattern as an attribute value
  * `condition` - to set a custom condition, by default we use `==`
  * `val` - to set custom condition value, by default we use the value from the provided terraform file



