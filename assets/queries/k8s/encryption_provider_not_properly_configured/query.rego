package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

providerList := {"aescbc", "kms", "secretbox"}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "EncryptionConfiguration"
	not containsProvider(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{EncryptionConfiguration}}.providers",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aescbc, kms or secretbox provider should be defined",
		"keyActualValue": "aescbc, kms or secretbox provider is not defined",
	}
}

containsProvider(resource){
	providerToCheck := providerList[_]
	innerResources := resource.resources[_]
	providers_det := innerResources["providers"]
	common_lib.valid_key(providers_det[_], providerToCheck)
}
