package Cx

CxPolicy [ result ] {
  resource := input.document[i]
  metadata := resource.metadata
  resource.kind == "ClusterRoleBinding"
  resource.roleRef.name == "cluster-admin"

	result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.roleRef.name=cluster-admin", [metadata.name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": "Ensure that the cluster-admin role is only used where required (RBAC)",
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' is binding 'cluster-admin' role with superuser permissions", [metadata.name, resource.kind])
  }
}
