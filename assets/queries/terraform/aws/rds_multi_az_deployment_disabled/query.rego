package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.multiaz == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s].multiaz", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'multiaz' should be set to true",
		"keyActualValue": "'multiaz' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "multiaz"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}


CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	not common_lib.valid_key(resource.multiaz)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'multiaz' should be defined and set to true",
		"keyActualValue": "'multiaz' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name], []),
	}
}
