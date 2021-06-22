package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_share_file[name]

	storageShareName := split(resource.storage_share_id, ".")[1]

	r := input.document[_].resource.azurerm_storage_share[storageShareName]
	permissions := r.acl.access_policy.permissions
	p := {"r", "w", "d", "l"}
	count({x | permission := p[x]; contains(permissions, permission)}) == 4

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_share[%s].acl.access_policy.permissions", [storageShareName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_storage_share[%s].acl.access_policy.permissions does not allow all ACL permissions", [storageShareName]),
		"keyActualValue": sprintf("azurerm_storage_share[%s].acl.access_policy.permissions allows all ACL permissions", [storageShareName]),
	}
}
