package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_security_group[name].ingress
  resource.from_port == 3389

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("aws_security_group[%s].ingress.from_port", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("aws_security_group[%s].ingress.from_port doesn't open the remote desktop port", [name]),
                "keyActualValue": 	sprintf("aws_security_group[%s].ingress.from_port opens the remote desktop port", [name]),
              }
}