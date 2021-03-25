package Cx

CxPolicy[result] {
	document := input.document[i]
	properties_json = document.resource.aws_batch_job_definition[name].container_properties
	properties := json.unmarshal(properties_json)
	properties.privileged == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_batch_job_definition[%s].container_properties.privileged", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_batch_job_definition[%s].container_properties.privileged is 'false' or not set", [name]),
		"keyActualValue": sprintf("aws_batch_job_definition[%s].container_properties.privileged is 'true'", [name]),
	}
}
