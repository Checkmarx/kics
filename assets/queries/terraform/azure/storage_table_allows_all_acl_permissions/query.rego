package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_table[name]

	permissions := resource.acl.access_policy.permissions

	p := {"r", "w", "d", "l"}

	count({x | permission := p[x]; contains(permissions, permission)}) == 4

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_table[%s].acl.permissions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_storage_table[%s].acl.permissions does not allow all ACL permissions", [name]),
		"keyActualValue": sprintf("azurerm_storage_table[%s].acl.permissions allows all ACL permissions", [name]),
	}
}
