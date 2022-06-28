package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])

	specInfo.spec.host_pid == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.host_pid", [resourceType, name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_pid' is undefined or false",
		"keyActualValue": "Attribute 'host_pid' is true",
	}
}
