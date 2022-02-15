package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	recommendedVersions := {
		"extensions/v1beta1": {
			"Deployment": "apps/v1",
			"DaemonSet": "apps/v1",
			"ReplicaSet": "apps/v1",
			"Ingress": "networking.k8s.io/v1",
			"NetworkPolicy": "networking.k8s.io/v1",
		},
		"apps/v1beta1": {
			"Deployment": "apps/v1",
			"ReplicaSet": "apps/v1",
			"StatefulSet": "apps/v1",
		},
		"apps/v1beta2": {
			"Deployment": "apps/v1",
			"DaemonSet": "apps/v1",
			"ReplicaSet": "apps/v1",
			"StatefulSet": "apps/v1",
		},
		"networking.k8s.io/v1beta1": {
			"Ingress": "networking.k8s.io/v1",
			"IngressClass": "networking.k8s.io/v1",
		},
		"rbac.authorization.k8s.io/v1beta1": {
			"ClusterRole": "rbac.authorization.k8s.io/v1",
			"ClusterRoleBinding": "rbac.authorization.k8s.io/v1",
			"Role": "rbac.authorization.k8s.io/v1",
			"RoleBinding": "rbac.authorization.k8s.io/v1",
		},
	}

	common_lib.valid_key(recommendedVersions[document.apiVersion], document.kind)
	result := {
		"documentId": document.id,
		"searchKey": sprintf("apiVersion={{%s}}", [document.apiVersion]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.apiVersion should be {{%s}}", [metadata.name, recommendedVersions[document.apiVersion][document.kind]]),
		"keyActualValue": sprintf("metadata.name={{%s}}.apiVersion is deprecated and is {{%s}}", [metadata.name, document.apiVersion]),
	}
}
