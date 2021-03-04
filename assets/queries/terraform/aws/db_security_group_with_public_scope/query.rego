package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_security_group[name].ingress
	resource.cidr == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_security_group[%s].ingress.cidr", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_db_security_group.ingress.cidr' != 0.0.0.0/0",
		"keyActualValue": "'aws_db_security_group.ingress.cidr'= 0.0.0.0/0",
	}
}
