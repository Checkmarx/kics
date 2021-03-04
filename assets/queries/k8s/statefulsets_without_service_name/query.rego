package Cx

CxPolicy[result] {
	document := input.document

	document[i].kind == "Service"
	specs := document[i].spec
	specs.clusterIP != "None"

	document[j].kind == "StatefulSet"
	document[j].spec.selector.matchLabels == document[j].spec.template.metadata.labels

	metadata := document[i].metadata

	metadata.name == document[j].spec.serviceName

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.serviceName", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.serviceName refers to a Headless Service", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.serviceName doesn't refers to a Headless Service", [metadata.name]),
	}
}
