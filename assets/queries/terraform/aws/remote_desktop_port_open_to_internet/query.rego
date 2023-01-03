package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	tf_lib.portOpenToInternet(resource.ingress, 3389)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress shouldn't open the remote desktop port (3389)", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress opens the remote desktop port (3389)", [name]),
	}
}
