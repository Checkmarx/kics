package Cx

import data.generic.common as common_lib
<<<<<<< HEAD
=======
import data.generic.terraform as tf_lib
>>>>>>> v1.5.10

CxPolicy[result] {
	storage := input.document[i].resource.azurerm_storage_account[name]
	storage.min_tls_version != "TLS1_2"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(storage, name),
		"searchKey": sprintf("azurerm_storage_account[%s].min_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s].min_tls_version' is 'TLS1_2'", [name]),
		"keyActualValue": sprintf("'azurerm_storage_account[%s].min_tls_version' is not 'TLS1_2'", [name]),
	}
}
