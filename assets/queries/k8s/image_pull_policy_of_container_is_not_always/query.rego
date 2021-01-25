package Cx

CxPolicy[result] {
	document := input.document
	metadata := document[i].metadata
	spec := document[i].spec
	containers := spec.containers
	containers[c].imagePullPolicy != "Always"

	not contains(containers[c].image, ":latest")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.name=%s.imagePullPolicy", [metadata.name, containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers.name=%s.imagePullPolicy should be Always", [metadata.name, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers.name=%s.imagePullPolicy is incorrect", [metadata.name, containers[c].name]),
	}
}
