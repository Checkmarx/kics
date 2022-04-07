package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "ServiceAccount"
	not common_lib.valid_key(resource, "automountServiceAccountToken")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kind={{ServiceAccount}}", []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "automountServiceAccountToken attribute should be defined and set to false",
		"keyActualValue": "automountServiceAccountToken attribute is not defined",
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "ServiceAccount"
	resource.automountServiceAccountToken == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kind={{ServiceAccount}}.automountServiceAccountToken", []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "automountServiceAccountToken attribute should be set to false",
		"keyActualValue": "automountServiceAccountToken attribute is set to true",
	}
}
