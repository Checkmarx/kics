package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])

	specInfo.spec.host_network == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.host_network", [resourceType, name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.host_network is undefined or set to false", [resourceType, name, specInfo.path]),
		"keyActualValue": sprintf("%s[%s].%s.host_network is set to true", [resourceType, name, specInfo.path]),
	}
}
