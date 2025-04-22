package Cx

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "ClusterRoleBinding"
	resource.roleRef.name == "cluster-admin"

	metadata := resource.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.roleRef.name=cluster-admin", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' of kind '%s' isn't binding 'cluster-admin' role with superuser permissions", [metadata.name, resource.kind]),
		"keyActualValue": sprintf("Resource name '%s' of kind '%s' is binding 'cluster-admin' role with superuser permissions", [metadata.name, resource.kind]),
	}
}
