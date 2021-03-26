package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	spec := document.spec.template.spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]
	cap := containers[c].securityContext.capabilities
	object.get(cap, "drop", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities", [metadata.name, types[x], containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.%s[%s].securityContext.capabilities.drop is Defined", [types[x], containers[c].name]),
		"keyActualValue": sprintf("spec.%s[%s].securityContext.capabilities.drop is not Defined", [types[x], containers[c].name]),
	}
}
