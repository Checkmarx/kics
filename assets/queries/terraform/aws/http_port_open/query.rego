package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_security_group[name].ingress
  resource.from_port == 80

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("aws_security_group[%s].ingress.from_port", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("aws_security_group[%s].ingress.from_port doesn't open the http port", [name]),
                "keyActualValue": 	sprintf("aws_security_group[%s].ingress.from_port opens the http port", [name]),
              }
}