package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	metadata := input.document[i].metadata
	specInfo := k8sLib.getSpecInfo(document)

	contexts := {"securityContext", "security_context"}
	properties := {"allowPrivilegeEscalation", "allow_privilege_escalation"}

	types := {"initContainers", "containers"}
	specInfo.spec[types[x]][_][contexts[c]][properties[p]] == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.%s.%s.%s.%s", [metadata.name, specInfo.path, types[x], contexts[c], properties[p]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.%s.%s.%s = false", [specInfo.path, types[x], contexts[c], properties[p]]),
		"keyActualValue": sprintf("%s.%s.%s.%s = true", [specInfo.path, types[x], contexts[c], properties[p]]),
	}
}
