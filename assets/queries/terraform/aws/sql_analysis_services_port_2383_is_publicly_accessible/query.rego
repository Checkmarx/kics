package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_security_group[name]

	tf_lib.portOpenToInternet(resource.ingress, 2383)

	result := {
		"documentId": doc.id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_security_group shouldn't open SQL Analysis Services Port 2383",
		"keyActualValue": "aws_security_group opens SQL Analysis Services Port 2383",
	}
}
