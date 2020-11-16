package Cx
 

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_default_vpc[name]

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_default_vpc[%s]", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'aws_default_vpc' should not exist",
                "keyActualValue":   "'aws_default_vpc' exists"
              }
}
CxPolicy [ result ] {
  aws_vpc := input.document[i].resource.aws_vpc[name]
  aws_vpc["default"]

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_vpc[%s].default", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'aws_vpc.default' is false",
                "keyActualValue":  "'aws_vpc.default' is true"
              }
}