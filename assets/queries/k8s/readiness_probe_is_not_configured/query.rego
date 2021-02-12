package Cx

CxPolicy[result] {
	document := input.document[i]
	object.get(document, "kind", "undefined") != "Job"
	object.get(document, "kind", "undefined") != "CronJob"

	some j
	types := {"initContainers", "containers"}
	container := document.spec[types[x]][j]

	object.get(container, "readinessProbe", "undefined") == "undefined"

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s", [metadata.name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'spec.%s[%d].readinessProbe' is set", [types[x], j]),
		"keyActualValue": sprintf("'spec.%s[%d].readinessProbe' is undefined", [types[x], j]),
	}
}
