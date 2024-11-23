package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	specInfo := k8sLib.getSpecInfo(document)
	serviceAccount := specInfo.spec.serviceAccountName

	document_other := input.document[j]
	i != j
	specInfo_other := k8sLib.getSpecInfo(document_other)
	serviceAccount_other := specInfo_other.spec.serviceAccountName

	serviceAccount == serviceAccount_other

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.serviceAccountName", [metadata.name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.serviceAccountName' should not be shared with other workloads", [specInfo.path]),
		"keyActualValue": sprintf("'%s.serviceAccountName' is shared with other workloads", [specInfo.path]),
	}
}
