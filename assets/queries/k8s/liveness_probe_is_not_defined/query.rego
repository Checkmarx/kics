package Cx

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec
	metadata := document.metadata
	kind := document.kind
	not check_kind(document.kind)

	containers := spec.containers
	exists_liveness_probe = object.get(containers[index], "livenessProbe", "undefined") == "undefined"
	exists_liveness_probe

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers[%d].name=%s", [metadata.name, index, containers[index].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s is defined", [metadata.name, index, containers[index].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s is undefined", [metadata.name, index, containers[index].name]),
	}
}

# Ignore 'Job' and 'CronJob'
check_kind(kind) {
	kind == "Job"
}

check_kind(kind) {
	kind == "CronJob"
}
