package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	types := {"kubernetes_pod": "spec.container", "kubernetes_deployment": "spec.template.spec.container"}
	resource_prefix := types[x]
	some document in input.document
	resource := document.resource[x][name]

	path := checkPath(resource)

	not common_lib.valid_key(path, "liveness_probe")

	result := {
		"documentId": document.id,
		"resourceType": x,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s", [x, name, resource_prefix]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'livenessProbe' should be defined and not null",
		"keyActualValue": "Attribute 'livenessProbe' is undefined or null",
	}
}

checkPath(resource) = path {
	path := resource.spec.template.spec.container
} else = path {
	path := resource.spec.container
}
