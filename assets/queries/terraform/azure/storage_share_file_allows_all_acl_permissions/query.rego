package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_share_file[name]

	storage_share := resource.storage_share_id
	attributeSplit := split(storage_share, ".")
	allows_all_permissions(attributeSplit[1], input.document[i].resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_share_file[%s].storage_share_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_storage_share_file[%s].storage_share_id does not allow all ACL permissions", [name]),
		"keyActualValue": sprintf("azurerm_storage_share_file[%s].storage_share_id allows all ACL permissions", [name]),
	}
}

allows_all_permissions(storage_share_name, resource) {
	r := resource.azurerm_storage_share[name]
	name == storage_share_name
	permissions := r.acl.access_policy.permissions
	p := {"r", "w", "d", "l"}
	count({x | permission := p[x]; contains(permissions, permission)}) == 4
}
