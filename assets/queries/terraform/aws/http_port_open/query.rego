package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	tf_lib.portOpenToInternet(resource.ingress, 80)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_security_group.ingress shouldn't open the HTTP port (80)",
		"keyActualValue": "aws_security_group.ingress opens the HTTP port (80)",
	}
}
