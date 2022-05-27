package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	types := {"kubernetes_pod": "spec.container", "kubernetes_deployment": "spec.template.spec.container"}
	resource_prefix := types[x]
	resource := input.document[i].resource[x][name]

	path := checkPath(resource)

	path.image_pull_policy != "Always"

	not contains(path.image, ":latest")
	result := {
		"documentId": input.document[i].id,
		"resourceType": x,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.image_pull_policy", [x, name, resource_prefix]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'image_pull_policy' should be defined as 'Always'",
		"keyActualValue": "Attribute 'image_pull_policy' is incorrect",
	}
}

checkPath(resource) = path {
	path := resource.spec.template.spec.container
} else = path {
	path := resource.spec.container
}
