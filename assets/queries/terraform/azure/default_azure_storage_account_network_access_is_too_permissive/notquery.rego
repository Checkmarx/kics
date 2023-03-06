package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib
import future.keywords.every
import future.keywords.in

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_storage_account[var0]
	resource_name := tf_lib.get_resource_name(resource, var0)
	networkRules := input.document[i].resource.azurerm_storage_account_network_rules[var1]
    networkRules.storage_account_id == sprintf("${azurerm_storage_account.%s.id}", [var0])
    lower(networkRules.default_action) == "allow"

    result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": resource_name,
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s].default_action", [var1]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_network_rules", var1, "default_action"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azurerm_storage_account_network_rules.default_action should be set to 'Deny'",
		"keyActualValue": "azurerm_storage_account_network_rules.default_action should be set to 'Allow'",
		"remediation": json.marshal({
			"before": "Allow",
			"after": "Deny",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_storage_account[var0]
	resource_name := tf_lib.get_resource_name(resource, var0)
    not has_net_rules_obj(resource_name, input.document[i])
    net_rules := object.get(resource, "network_rules", {})
    lower(net_rules.default_action) == "allow"

    result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": resource_name,
		"searchKey": sprintf("azurerm_storage_account.network_rules[%s].default_action", [resource_name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", resource_name, "network_rules", "default_action"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azurerm_storage_account.network_rules.default_action should be set to 'Deny'",
		"keyActualValue": "azurerm_storage_account.network_rules.default_action should be set to 'Allow'",
		"remediation": json.marshal({
			"before": "Allow",
			"after": "Deny",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_storage_account[var0]
    resource_name := tf_lib.get_resource_name(resource, var0)
    has_key(resource, "public_network_access_enabled")
    resource.public_network_access_enabled

    result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": resource_name,
		"searchKey": sprintf("azurerm_storage_account[%s].public_network_access_enabled", [var0]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", resource_name, "public_network_access_enabled"], []),
		"issueType": "IncorrectValue",
		"keyActualValue": "azurerm_storage_account.public_network_access_enabled is set to 'true'",
		"keyExpectedValue": "azurerm_storage_account.public_network_access_enabled should be set to 'false'",
		"remediation": json.marshal({
			"before": true,
			"after": false,
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_storage_account[var0]
    resource_name := tf_lib.get_resource_name(resource, var0)
    not has_key(resource, "public_network_access_enabled")

    result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": resource_name,
		"searchKey": sprintf("azurerm_storage_account[%s].public_network_access_enabled", [var0]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", resource_name, "public_network_access_enabled"], []),
		"issueType": "IncorrectValue",
		"keyActualValue": "azurerm_storage_account.public_network_access_enabled is not set (default is 'true')",
		"keyExpectedValue": "azurerm_storage_account.public_network_access_enabled should be set to 'false'",
		"remediation": "public_network_access_enabled = false",
		"remediationType": "addition",
	}
}

has_key(x, k) {
	_ = x[k]
}

has_net_rules_obj(res_name, all_resources) = true {
	has_key(all_resources, "azurerm_storage_account_network_rules")
	every rule in all_resources.resource.azurerm_storage_account_network_rules {
        rule.storage_account_id != sprintf("${azurerm_storage_account.%s.id}", [res_name])
    }
} else = false
