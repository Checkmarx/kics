package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]

    not has_network_rules(resource)

	result := {
        "documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, name), 
		"searchKey": sprintf("azurerm_storage_account[%s]", [name]), 
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'network_rules' should be defined and not null",
		"keyActualValue": "'network_rules' is undefined or null",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]
    
    res := has_bypass_field(resource, name)
    
    bypass_field_exists := res["has_bypass_field"]
    
    not bypass_field_exists
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_storage_account[name], name), 
		"searchKey": res["search_key_value"], 
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'network_rules.bypass' should be defined and not null",
		"keyActualValue": "'network_rules.bypass' is undefined or null",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]
	bypass := resource.network_rules.bypass
	not common_lib.inArray(bypass, "AzureServices") 

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, name), 
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules.bypass", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'network_rules.bypass' should contain 'AzureServices'",
		"keyActualValue": "'network_rules.bypass' does not contain 'AzureServices'",
	}
}

CxPolicy[result] {
	resource := input.document[_].resource.azurerm_storage_account[name]
	bypass := input.document[j].variable.network_rules_list["default"][_].bypass

    not common_lib.inArray(bypass, "AzureServices") 

	result := {
		"documentId": input.document[j].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, name), 
		"searchKey": "variable.network_rules_list.default.bypass",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'network_rules.bypass' should contain 'AzureServices'",
		"keyActualValue": "'network_rules.bypass' does not contain 'AzureServices'",
	}
}


CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account_network_rules[name]
	not common_lib.valid_key(resource, "bypass") 

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account_network_rules",
		"resourceName": tf_lib.get_resource_name(resource, name), 
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'bypass' should be defined and not null",
		"keyActualValue": "'bypass' is undefined or null",
	}
}

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account_network_rules[name]
	bypass := network_rules.bypass
	not common_lib.inArray(bypass, "AzureServices") 

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account_network_rules",
		"resourceName": tf_lib.get_resource_name(network_rules, name), 
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s].bypass", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'bypass' should contain 'AzureServices'",
		"keyActualValue": "'bypass' does not contain 'AzureServices'",
	}
}

has_network_rules(resource) {
	not common_lib.valid_key(resource, "network_rules") 
    common_lib.valid_key(resource, "dynamic") 
    common_lib.valid_key(resource.dynamic, "network_rules") 
    not common_lib.emptyOrNull(resource.dynamic.network_rules) 
} else {
	common_lib.valid_key(resource, "network_rules") 
    not common_lib.emptyOrNull(resource.network_rules) 
}

has_bypass_field(resource, name) = res { 
	network_rules_content := resource.dynamic.network_rules.content
    has_bypass := common_lib.valid_key(network_rules_content, "bypass")
    res := {
    	"search_key_value" : sprintf("azurerm_storage_account[%s].dynamic.network_rules.content", [name]),
        "has_bypass_field" : has_bypass,
    }
} else = res { 
	network_rules_content := resource.network_rules
    has_bypass := common_lib.valid_key(network_rules_content, "bypass")
	res := {
    	"search_key_value" : sprintf("azurerm_storage_account[%s].network_rules", [name]),
        "has_bypass_field" : has_bypass,
    }
}
