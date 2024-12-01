package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_security_group[name]

	tf_lib.portOpenToInternet(resource.ingress, 80)

	result := {
		"documentId": document.id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_security_group.ingress shouldn't open the HTTP port (80)",
		"keyActualValue": "aws_security_group.ingress opens the HTTP port (80)",
	}
}
