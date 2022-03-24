package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib


CxPolicy[result] {
	resource:= input.document[i]
    resource.kind == "AdmissionConfiguration"
	not hasImagePolicyWebhook(resource.plugins)
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kind={{AdmissionConfiguration}}.plugins", []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ImagePolicyWebhook' should be defined in the AdmissionConfiguration plugins",
		"keyActualValue":  "'ImagePolicyWebhook' is not defined in the AdmissionConfiguration plugins",
	}
}

hasImagePolicyWebhook(plugins){
	plugins[_].name == "ImagePolicyWebhook"
}
