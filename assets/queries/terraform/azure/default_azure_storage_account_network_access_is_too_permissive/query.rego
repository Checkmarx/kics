package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[var0]
	resource_name := tf_lib.get_resource_name(resource, var0)
	networkRules := get_network_rules(resource, var0)

	res1 := publicNetworkAccessEnabled(resource)
	res2 := aclsDefaultActionAllow(networkRules)

	issue := prepare_issue(res1, res2)
	searchLine := get_search_line(resource_name, networkRules)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": resource_name,
		"searchKey": sprintf("azurerm_storage_account[%s]", [var0]),
		"searchLine": searchLine,
		"issueType": issue.issueType,
		"keyExpectedValue": issue.kev,
		"keyActualValue": issue.kav,
		"remediation": issue.remediation,
		"remediationType": issue.remediationType,
	}
}

get_search_line(name, rules) = line {
    rules.resource_group_name
    line := common_lib.build_search_line(["resource", "azurerm_storage_account_network_rules", name, "default_action"], [])
} else = line {
    not rules.resource_group_name
    line := common_lib.build_search_line(["resource", "azurerm_storage_account", name], [])
}

get_network_rules(storage_account, storage_account_name) = rules {
	networkRules := input.document[i].resource.azurerm_storage_account_network_rules[var1]
    networkRules.storage_account_id == sprintf("${azurerm_storage_account.%s.id}", [storage_account_name])
    rules := networkRules
} else = rules {
	rules := storage_account.network_rules
} else = rules {
	rules := null
}

publicNetworkAccessEnabled(sa) = reason {
	not sa.public_network_access_enabled
	not sa.public_network_access_enabled == false
	reason := "not defined"
} else = reason {
	sa.public_network_access_enabled == true
	reason := "enabled"
}

aclsDefaultActionAllow(network_rules) = reason {
	is_null(network_rules)
	reason := "not defined"
} else = reason {
    not network_rules.default_action
    reason := "not defined"
} else = reason {
	da := network_rules.default_action
	lower(da) == "allow"
	reason := "allow"
}

prepare_issue(val1, val2) = issue {
	val1 == "not defined"
	val2 == "not defined"
	issue := {
		"kav": "azurerm_storage_account.public_network_access_enabled is not set (default is 'true')",
		"kev": "azurerm_storage_account.public_network_access_enabled should be set to 'false'",
		"issueType": "MissingAttribute",
		"remediation": "public_network_access_enabled = false",
		"remediationType": "addition",
	}
} else = issue {
	val1 == "enabled"
	issue := {
		"kav": "azurerm_storage_account.public_network_access_enabled set to 'true'",
		"kev": "azurerm_storage_account.public_network_access_enabled should be set to 'false'",
		"issueType": "IncorrectValue",
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
} else = issue {
	val2 == "allow"
	issue := {
		"kav": "azurerm_storage_account.network_rules.default_action is set to 'Allow'",
		"kev": "azurerm_storage_account.network_rules.default_action should be set to 'Deny'",
		"issueType": "IncorrectValue",
		"remediation": json.marshal({
			"before": "Allow",
			"after": "Deny"
		}),
		"remediationType": "replacement",
	}
}