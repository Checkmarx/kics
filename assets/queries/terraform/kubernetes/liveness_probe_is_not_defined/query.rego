package Cx

import data.generic.common as common_lib

CxPolicy[result] {

    types := {"kubernetes_pod": "spec.container", "kubernetes_deployment": "spec.template.spec.container"}
	resource_prefix  := types[x]
	resource := input.document[i].resource[x][name]

    path := checkPath(resource)

	not common_lib.valid_key(path, "liveness_probe")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s", [x, name, resource_prefix]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'livenessProbe' is defined and not null",
		"keyActualValue": "Attribute 'livenessProbe' is undefined or null",
	}
}

checkPath(resource) = path{
	path := resource.spec.template.spec.container
}else = path{
	path := resource.spec.container
}
