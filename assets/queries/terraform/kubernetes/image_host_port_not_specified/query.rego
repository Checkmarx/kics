package Cx

CxPolicy[result] {
	types := {"kubernetes_pod": "spec.container", "kubernetes_deployment": "spec.template.spec.container"}
	resource_prefix := types[x]
	resource := input.document[i].resource[x][name]

	path := checkPath(resource)

	object.get(path.port, "host_port", "undefined") == "undefined"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.port", [x, name, resource_prefix]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_port' is defined",
		"keyActualValue": "Attribute 'host_port' is undefined",
	}
}

checkPath(resource) = path {
	path := resource.spec.template.spec.container
} else = path {
	path := resource.spec.container
}
