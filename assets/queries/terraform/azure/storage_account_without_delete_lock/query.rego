package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	locks 	 := [lock | lock := input.document[_].resource.azurerm_management_lock]

	resource := input.document[i].resource.azurerm_storage_account[name]

	not has_valid_lock(resource, name, locks)
	results := get_results(resource, name, locks)[_]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey" : sprintf("azurerm_storage_account[%s]", [name]),
		"issueType": results.issueType,
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s]' should be associated with an 'azurerm_management_lock' where lock_level is set to 'CanNotDelete'", [name]),
		"keyActualValue" : results.keyActualValue,
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_storage_account", name], [])
	}
}

get_results(resource, acc_name, locks) = results {
	locks[doc][name].scope == [sprintf("${azurerm_storage_account.%s.id}",[acc_name]), sprintf("${azurerm_resource_group.%s.id}",[split(resource.resource_group_name,".")[1]])][_]
	locks[doc][name].lock_level != "CanNotDelete"
	results := [{
		"issueType": "IncorrectValue",
		"keyActualValue" : sprintf("'azurerm_storage_account[%s]' is associated with 'azurerm_management_lock[%s]' but lock_level is '%s'", [acc_name, name, locks[doc][name].lock_level])
	}]
} else = results {
	results := [{
		"issueType": "MissingAttribute",
		"keyActualValue" : sprintf("'azurerm_storage_account[%s]' is not associated with an 'azurerm_management_lock'", [acc_name])
	}]
}

has_valid_lock(resource, acc_name, locks) {
	locks[doc][name].scope == sprintf("${azurerm_storage_account.%s.id}",[acc_name])
	locks[doc][name].lock_level == "CanNotDelete"
} else {
	locks[doc][name].scope == sprintf("${azurerm_resource_group.%s.id}",[split(resource.resource_group_name,".")[1]])
	locks[doc][name].lock_level == "CanNotDelete"
}
