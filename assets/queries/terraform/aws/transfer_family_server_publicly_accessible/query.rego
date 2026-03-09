package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_transfer_server[name]
	endpoint := object.get(resource, "endpoint_type", "PUBLIC")
	endpoint != "VPC"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_transfer_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_transfer_server[%s].endpoint_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_transfer_server[%s].endpoint_type' should be 'VPC'", [name]),
		"keyActualValue": sprintf("'aws_transfer_server[%s].endpoint_type' is '%s'", [name, endpoint]),
		"searchLine": common_lib.build_search_line(["resource", "aws_transfer_server", name, "endpoint_type"], []),
		"remediation": "endpoint_type = \"VPC\"",
		"remediationType": "replacement",
	}
}
