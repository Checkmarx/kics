package Cx

CxPolicy[result] {
	document := input.document
	metadata := document[i].metadata
	spec := document[i].spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]
	containers[c].imagePullPolicy != "Always"

	not contains(containers[c].image, ":latest")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.imagePullPolicy", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.imagePullPolicy should be Always", [metadata.name, types[x], containers[c].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.imagePullPolicy is incorrect", [metadata.name, types[x], containers[c].name]),
	}
}
