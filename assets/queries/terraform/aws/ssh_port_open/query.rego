package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_security_group[name].ingress
  resource.cidr_blocks[i] == "0.0.0.0/0"
  portNumber := 22
  resource.from_port <= portNumber
  resource.to_port >= portNumber

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("aws_security_group[%s].ingress", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("aws_security_group[%s].ingress doesn't open the ssh port", [name]),
                "keyActualValue": 	sprintf("aws_security_group[%s].ingress opens the ssh port", [name]),
              }
}