package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_cluster_role_binding[name]
	resource.role_ref.name == "cluster-admin"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_cluster_role_binding",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_cluster_role_binding[%s].role_ref.name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' isn't binding 'cluster-admin' role with superuser permissions", [name]),
		"keyActualValue": sprintf("Resource name '%s' is binding 'cluster-admin' role with superuser permissions", [name]),
	}
}
