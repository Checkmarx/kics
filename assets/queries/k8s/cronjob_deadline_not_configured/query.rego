package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec
	metadata := document.metadata
	kind := document.kind
	kind == "CronJob"
	not common_lib.valid_key(spec, "startingDeadlineSeconds")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "spec.startingDeadlineSeconds is defined",
		"keyActualValue": "spec.startingDeadlineSeconds is not defined",
	}
}
