package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[var0]
	resource_name := tf_lib.get_resource_name(resource, var0)
	networkRules := get_network_rules(resource, var0)

	res1 := publicNetworkAccessEnabled(resource)
	res2 := aclsDefaultActionAllow(networkRules.rules)

	issue := prepare_issue(res1, res2, var0, networkRules.type, networkRules.key)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": resource_name,
		"searchKey": issue.searchKey,
		"searchLine": issue.searchLine,
		"issueType": issue.issueType,
		"keyExpectedValue": issue.kev,
		"keyActualValue": issue.kav,
		"remediation": issue.remediation,
		"remediationType": issue.remediationType,
	}
}

prepare_issue(res1, res2, resource_id, rules_type, rules_key) = issue {
    res1 == "not defined"
	res2 == "not defined"
	issue := {
		"kav": "azurerm_storage_account.public_network_access_enabled is not set (default is 'true')",
		"kev": "azurerm_storage_account.public_network_access_enabled should be set to 'false'",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", resource_id, "public_network_access_enabled"], []),
		"searchKey": sprintf("azurerm_storage_account[%s].public_network_access_enabled", [resource_id]),
		"issueType": "MissingAttribute",
		"remediation": "public_network_access_enabled = false",
		"remediationType": "addition",
	}
} else = issue {
    res1 == "enabled"
    issue := {
		"kav": "azurerm_storage_account.public_network_access_enabled set to 'true'",
		"kev": "azurerm_storage_account.public_network_access_enabled should be set to 'false'",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", resource_id, "public_network_access_enabled"], []),
		"searchKey": sprintf("azurerm_storage_account[%s].public_network_access_enabled", [resource_id]),
		"issueType": "IncorrectValue",
		"remediation": json.marshal({
			"before": "true",
			"after": "false",
		}),
		"remediationType": "replacement",
	}
} else = issue {
    res2 == "allow"
    rules_type == "inline"
    issue := {
		"kav": "azurerm_storage_account.network_rules.default_action is set to 'Allow'",
		"kev": "azurerm_storage_account.network_rules.default_action should be set to 'Deny'",
		"issueType": "IncorrectValue",
		"remediation": json.marshal({
			"before": "Allow",
			"after": "Deny",
		}),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", resource_id, "network_rules", "default_action"], []),
        "searchKey": sprintf("azurerm_storage_account[%s].network_rules.default_action", [resource_id]),
        "remediationType": "replacement",
	}
} else = issue {
    res2 == "allow"
    rules_type == "object"
    issue := {
		"kav": "azurerm_storage_account_network_rules.default_action is set to 'Allow'",
		"kev": "azurerm_storage_account_network_rules.default_action should be set to 'Deny'",
		"issueType": "IncorrectValue",
		"remediation": json.marshal({
			"before": "Allow",
			"after": "Deny",
		}),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_network_rules", rules_key, "default_action"], []),
        "searchKey": sprintf("azurerm_storage_account_network_rules[%s].default_action", [rules_key]),
        "remediationType": "replacement",
	}
}

get_network_rules(storage_account, storage_account_name) = rules {
	networkRules := input.document[i].resource.azurerm_storage_account_network_rules[var1]
    networkRules.storage_account_id == sprintf("${azurerm_storage_account.%s.id}", [storage_account_name])
    rules := {
        "rules": object.union(networkRules, {"name": var1}),
        "type": "object",
        "key": var1
    }
} else = rules {
	rules := {
	    "rules": storage_account.network_rules,
	    "type": "inline",
	    "key": null
    }
} else = rules {
	rules := {
	    "rules": null,
	    "type": null,
	    "key": null
	}
}

publicNetworkAccessEnabled(sa) = reason {
    not has_key(sa, "public_network_access_enabled")
	reason := "not defined"
} else = reason {
	sa.public_network_access_enabled == true
	reason := "enabled"
}

aclsDefaultActionAllow(network_rules) = reason {
	is_null(network_rules)
	reason := "not defined"
} else = reason {
	lower(network_rules.default_action) == "allow"
	reason := "allow"
}

has_key(x, k) {
	_ = x[k]
}
