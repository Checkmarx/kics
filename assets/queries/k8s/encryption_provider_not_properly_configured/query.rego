package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "EncryptionConfiguration"
	not containsProvider(resource, "aescbc")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "kind={{EncryptionConfiguration}}.providers",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aescbc provider should be defined",
		"keyActualValue": "aescbc provider is not defined",
	}
}

containsProvider(resource, providerToCheck){
	innerResources := resource.resources[_]
	providers := innerResources["providers"]
	common_lib.valid_key(providers[_], providerToCheck)
}
