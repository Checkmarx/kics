package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudtrail[name]

	resource.event_selector.data_resource.type == "AWS::S3::Object"
	not common_lib.valid_key(resource.event_selector, "read_write_type")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudtrail[%s].event_selector", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'read_write_type' should be defined and not null",
		"keyActualValue": "'read_write_type' is undefined or null",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudtrail[name]

	resource.event_selector.data_resource.type == "AWS::S3::Object"
	resource.event_selector.read_write_type != "All"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudtrail[%s].event_selector.read_write_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'read_write_type' should be set to 'All'",
		"keyActualValue": "'read_write_type' is not set to 'All'",
	}
}
