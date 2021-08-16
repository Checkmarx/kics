package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	types := {"kubernetes_pod": "spec.container", "kubernetes_deployment": "spec.template.spec.container"}
	resource_prefix := types[x]
	resource := input.document[i].resource[x][name]

	path := checkPath(resource)

	not common_lib.valid_key(path.port, "host_port")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.port", [x, name, resource_prefix]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_port' is defined and not null",
		"keyActualValue": "Attribute 'host_port' is undefined or null",
	}
}

checkPath(resource) = path {
	path := resource.spec.template.spec.container
} else = path {
	path := resource.spec.container
}
