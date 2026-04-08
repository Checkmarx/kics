package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_managed_disk[name]

	not has_disk_encryption(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_managed_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_managed_disk[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_managed_disk[%s]' should set a 'disk_encryption_set_id' or 'secure_vm_disk_encryption_set_id'", [name]),
		"keyActualValue": sprintf("'azurerm_managed_disk[%s]' does not set a disk encryption id field", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_managed_disk", name], []),
	}
}

has_disk_encryption(resource) {
	common_lib.valid_key(resource, "disk_encryption_set_id")
} else {
	common_lib.valid_key(resource, "secure_vm_disk_encryption_set_id")
}
