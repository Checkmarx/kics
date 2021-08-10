package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	recommendedVersions := {
		"extensions/v1beta1": {
			"Deployment": "apps/v1",
			"DaemonSet": "apps/v1",
			"Ingress": "apps/v1",
		},
		"apps/v1beta1": {
			"Deployment": "apps/v1",
			"StatefulSet": "apps/v1",
		},
		"apps/v1beta2": {
			"Deployment": "apps/v1",
			"DaemonSet": "apps/v1",
			"StatefulSet": "apps/v1",
		},
	}

	common_lib.valid_key(recommendedVersions[document.apiVersion], document.kind)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("apiVersion=%s", [document.apiVersion]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'apiVersion' should be %s", [recommendedVersions[document.apiVersion][document.kind]]),
		"keyActualValue": sprintf("'apiVersion' is deprecated and is %s", [document.apiVersion]),
	}
}
