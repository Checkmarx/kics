package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some i, resourceType, name, key
	some document in input.document
	resource := document.resource[resourceType]

	labels := resource[name].metadata.labels

	regex.match(`^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$`, labels[key]) == false

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].metadata.labels", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].metada.labels[%s] has valid label", [resourceType, name, key]),
		"keyActualValue": sprintf("%s[%s].metada.labels[%s] has invalid label", [resourceType, name, key]),
	}
}
