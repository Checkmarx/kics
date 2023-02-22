package Cx

import data.generic.terraform as tf_ib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[var0]

	res1 := publicNetworkAccessEnabled(resource)
	res2 := aclsDefaultActionAllow(resource)

	issue := prepare_issue(res1, res2)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_ib.get_resource_name(resource, var0),
		"searchKey": sprintf("azurerm_storage_account[%s]", [var0]),
		"issueType": issue.issueType,
		"keyExpectedValue": issue.kev,
		"keyActualValue": issue.kav,
	}
}

publicNetworkAccessEnabled(sa) = reason {
	not sa.public_network_access_enabled
	not sa.public_network_access_enabled == false
	reason := "not defined"
} else = reason {
	sa.public_network_access_enabled == true
	reason := "enabled"
}

aclsDefaultActionAllow(sa) = reason {
	not sa.network_rules.default_action
	reason := "not defined"
} else = reason {
	da := sa.network_rules.default_action
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
	}
} else = issue {
	val1 == "enabled"
	issue := {
		"kav": "azurerm_storage_account.public_network_access_enabled set to 'true'",
		"kev": "azurerm_storage_account.public_network_access_enabled should be set to 'false'",
		"issueType": "IncorrectValue",
	}
} else = issue {
	val2 == "allow"
	issue := {
		"kav": "azurerm_storage_account.network_rules.default_action is set to 'Allow'",
		"kev": "azurerm_storage_account.network_rules.default_action should be set to 'Deny'",
		"issueType": "IncorrectValue",
	}
}