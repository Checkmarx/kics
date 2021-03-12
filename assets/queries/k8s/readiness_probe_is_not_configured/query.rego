package Cx

import data.generic.k8s as k8s

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
    listKinds := ["Job", "CronJob"]

	not k8s.checkKind(kind, listKinds)

	some j
	types := {"initContainers", "containers"}
	container := document.spec[types[x]][j]

	object.get(container, "readinessProbe", "undefined") == "undefined"

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}", [metadata.name, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'spec.%s.name={{%s}}.readinessProbe' is set", [types[x], container.name]),
		"keyActualValue": sprintf("'spec.%s.name={{%s}}.readinessProbe' is undefined", [types[x], container.name]),
	}
}
