package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azurerm_storage_table[name]

	permissions := resource.acl.access_policy.permissions

	p := {"r", "w", "d", "l"}

	count({x | permission := p[x]; contains(permissions, permission)}) == 4

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_storage_table",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_storage_table[%s].acl.permissions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_storage_table[%s].acl.permissions should not allow all ACL permissions", [name]),
		"keyActualValue": sprintf("azurerm_storage_table[%s].acl.permissions allows all ACL permissions", [name]),
	}
}
