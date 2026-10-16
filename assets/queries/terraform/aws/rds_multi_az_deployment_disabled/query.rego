package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.multi_az == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s].multi_az", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'multi_az' should be set to true",
		"keyActualValue": "'multi_az' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "multi_az"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}


CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	not common_lib.valid_key(resource, "multi_az")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'multi_az' should be defined and set to false",
		"keyActualValue": "'multi_az' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name], []),
	}
}
