package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
    object.get(spec, "host_aliases", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.host_aliases is defined", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.host_aliases is undefined", [name]),
	}
}
