package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource
  ingress := resource.aws_security_group[name].ingress
  ingress.cidr_blocks[i] == "0.0.0.0/0"
  portNumber := 2383
  ingress.from_port <= portNumber
  ingress.to_port >= portNumber

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("aws_security_group[%s].ingress.cidr_blocks is not public", [name]),
                "keyActualValue": 	sprintf("aws_security_group[%s].ingress.cidr_blocks is public", [name]),
              }
             
}