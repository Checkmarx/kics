package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_transfer_server[name]
	common_lib.valid_key(resource, "endpoint_type")
	resource.endpoint_type != "VPC"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_transfer_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_transfer_server[%s].endpoint_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_transfer_server[%s].endpoint_type' should be 'VPC'", [name]),
		"keyActualValue": sprintf("'aws_transfer_server[%s].endpoint_type' is '%s'", [name, resource.endpoint_type]),
		"searchLine": common_lib.build_search_line(["resource", "aws_transfer_server", name, "endpoint_type"], []),
		"remediation": "endpoint_type = \"VPC\"",
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_transfer_server[name]
	not common_lib.valid_key(resource, "endpoint_type")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_transfer_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_transfer_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_transfer_server[%s].endpoint_type' should be defined and set to 'VPC'", [name]),
		"keyActualValue": sprintf("'aws_transfer_server[%s].endpoint_type' is undefined (defaults to 'PUBLIC')", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_transfer_server", name], []),
		"remediation": "endpoint_type = \"VPC\"",
		"remediationType": "addition",
	}
}
