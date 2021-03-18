package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	metadata := document.metadata
	spec := document.spec
	not k8sLib.compareArrays(spec.requiredDropCapabilities, ["ALL", "NET_RAW"])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.requiredDropCapabilities", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "spec.requiredDropCapabilities 'is ALL or NET_RAW'",
		"keyActualValue": "spec.requiredDropCapabilities 'is not ALL or NET_RAW'",
	}
}
