package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])

	specInfo.spec.host_ipc == true

	result := {
		"documentId": document.id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.host_ipc", [resourceType, name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_ipc' should be undefined or false",
		"keyActualValue": "Attribute 'host_ipc' is true",
		"searchLine": common_lib.build_search_line([resourceType, name, specInfo.path], ["host_ipc"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false",
		}),
		"remediationType": "replacement",
	}
}
