package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	properties_json = document.resource.aws_batch_job_definition[name].container_properties
	properties := json.unmarshal(properties_json)
	properties.privileged == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_batch_job_definition",
		"resourceName": tf_lib.get_resource_name(document.resource.aws_batch_job_definition[name], name),
		"searchKey": sprintf("aws_batch_job_definition[%s].container_properties.privileged", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_batch_job_definition[%s].container_properties.privileged is 'false' or not set", [name]),
		"keyActualValue": sprintf("aws_batch_job_definition[%s].container_properties.privileged is 'true'", [name]),
	}
}
