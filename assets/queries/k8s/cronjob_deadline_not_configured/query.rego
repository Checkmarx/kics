package Cx

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec
	metadata := document.metadata
	kind := document.kind
	kind == "CronJob"
	object.get(spec, "startingDeadlineSeconds", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "spec.startingDeadlineSeconds is defined",
		"keyActualValue": "spec.startingDeadlineSeconds is not defined",
	}
}
