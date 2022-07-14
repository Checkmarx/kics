package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])

	specInfo.spec.host_ipc == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.host_ipc", [resourceType, name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_ipc' should be undefined or false",
		"keyActualValue": "Attribute 'host_ipc' is true",
		"searchLine": common_lib.build_search_line([resourceType, name, specInfo.path],["host_ipc"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
