package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]
	not common_lib.valid_key(resource, "enable_https_traffic_only")
	not common_lib.valid_key(resource, "https_traffic_only_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_storage_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_storage_account.%s.enable_https_traffic_only' equals 'true', or (since Terraform v4.0) 'azurerm_storage_account.%s.https_traffic_only_enabled' equals 'true'", [name, name]),
		"keyActualValue": sprintf("Neither 'azurerm_storage_account.%s.enable_https_traffic_only' nor 'azurerm_storage_account.%s.https_traffic_only_enabled' exists", [name, name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_storage_account", name], []),
		"remediation": "https_traffic_only_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]
    field := get_https_field_to_check(resource)
    resource[field] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_storage_account[%s].%s", [name,field]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_storage_account.%s.%s' equals 'true'", [name,field]),
		"keyActualValue": sprintf("'azurerm_storage_account.%s.%s' equals 'false'", [name,field]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_storage_account" ,name, field], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

get_https_field_to_check(resource) = field {
	common_lib.valid_key(resource, "enable_https_traffic_only")
    field = "enable_https_traffic_only"
} else = "https_traffic_only_enabled" {
    common_lib.valid_key(resource, "https_traffic_only_enabled")
    field = "https_traffic_only_enabled"
}
