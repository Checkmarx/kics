package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib
import future.keywords.in

providerList := {"aescbc", "kms", "secretbox"}

CxPolicy[result] {
	some resource in input.document
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

containsProvider(resource) {
	providerToCheck := providerList[_]
	innerResources := resource.resources[_]
	providers_det := innerResources.providers
	common_lib.valid_key(providers_det[_], providerToCheck)
}
