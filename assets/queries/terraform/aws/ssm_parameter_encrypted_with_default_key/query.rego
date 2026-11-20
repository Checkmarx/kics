package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ssm_parameter[name]
    resource.type == "SecureString"
	not common_lib.valid_key(resource, "key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ssm_parameter",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ssm_parameter[%s].type", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'key_id' should be defined",
		"keyActualValue": "'key_id' is undefined",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssm_parameter", name, "type"], []),
	}
}
