package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_share_file[name]

	storageShareName := split(resource.storage_share_id, ".")[1]

	r := input.document[_].resource.azurerm_storage_share[storageShareName]
	permissions := r.acl.access_policy.permissions
	p := {"r", "w", "d", "l"}
	count({x | permission := p[x]; contains(permissions, permission)}) == 4

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_share",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_storage_share[%s].acl.access_policy.permissions", [storageShareName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_storage_share[%s].acl.access_policy.permissions should not allow all ACL permissions", [storageShareName]),
		"keyActualValue": sprintf("azurerm_storage_share[%s].acl.access_policy.permissions allows all ACL permissions", [storageShareName]),
	}
}
