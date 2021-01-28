# Query by Example - the tool for query auto-generation

## What does this tool do

The query auto-generation tool generates queries by examples: its input is an example of a source file with security issues, 
when there is a special comment marks lines with security issues;
its output is a query source in REGO format.

## Example

### Terraform file with security issues marked with comments

```terraform
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTP" //IncorrectValue:"group=rule1,upper,resource=['aws_lb_listener','aws_alb_listener']"

  default_action {
    type = "redirect"

    redirect {
      port        = "80"
      protocol    = "HTTP" //IncorrectValue:"group=rule1,upper,condition=!=,val=HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "8080"
  protocol          = "HTTP" //IncorrectValue:"group=rule2,upper,resource=['aws_lb_listener','aws_alb_listener']"

  default_action {
    redirect {
      protocol = "any" //MissingAttribute:"group=rule2"
    }
  }
}
```

### Auto-generated Query in REGO format

```rego
package Cx

CxPolicy [ result ] {
    document := input.document[i]
    block := document.resource
    blockTypes := {"aws_alb_listener", "aws_lb_listener"}

    upper(block[blockTypes[blockIndex]][name].protocol) == "HTTP"
    upper(block[blockTypes[blockIndex]][name].default_action.redirect.protocol) != "HTTPS"

    result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("%s[%s].default_action.redirect.protocol", [blockTypes[blockIndex], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'default_action.redirect.protocol' should be valid",
                "keyActualValue": 	"'default_action.redirect.protocol' is invalid"
              }
}

CxPolicy [ result ] {
    document := input.document[i]
    block := document.resource
    blockTypes := {"aws_lb_listener", "aws_alb_listener"}

    upper(block[blockTypes[blockIndex]][name].protocol) == "HTTP"
    not block[blockTypes[blockIndex]][name].default_action.redirect.protocol

    result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("%s[%s].default_action.redirect.protocol", [blockTypes[blockIndex], name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'default_action.redirect.protocol' should be valid",
                "keyActualValue": 	"'default_action.redirect.protocol' is invalid"
              }
}
```

## How to run

```sh
go run cmd/builder/main.go -i ./cmd/builder/example.tf -o ./out.rego
```

Where `-i` - terraform file to parse, `-o` result query.

Please ensure you have downloaded all tool dependencies, to do that please execute:

```sh
go mod download
go mod vendor
```

## Supported Comment

The tool supports only comments which have Golang struct tag syntax, for example `// Comment:"attribute1,attribute2=value" Comment2`. (note: space is not allowed in comments attributes).
For more example please take a look at the example files.

Supported comment:

*   `MissingAttribute`

*   `RedundantAttribute`

*   `IncorrectValue`
    *   `resource` - to target a resource, can be `resource=*`, `resource=['s3_bucket','sqs_queue']`, by default resource from terraform file will be used 
    *   `any_key` - allow any element in condition, example `resosource.vars.name -> resource.vars[_]`
    *   `upper/lower` - to wrap condition, example `resosource.vars.name -> upper(resource.vars.name)`
    *   `regex` - use `re_match` for a condition, should be provided with a regex pattern as an attribute value
    *   `condition` - to set a custom condition, by default we use `==`
    *   `val` - to set custom condition value, by default we use the value from the provided terraform file
  