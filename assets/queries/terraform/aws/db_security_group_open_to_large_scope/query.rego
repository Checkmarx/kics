package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_db_security_group[name].ingress
	hosts := split(resource.cidr, "/")
	to_number(hosts[1]) <= 24

	result := {
		"documentId": document.id,
		"resourceType": "aws_db_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_security_group[%s].ingress.cidr", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_db_security_group.ingress.cidr' > 24",
		"keyActualValue": "'aws_db_security_group.ingress.cidr' <= 24",
	}
}
