package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	door := document.resource.azurerm_frontdoor[name].frontend_endpoint

	not common_lib.valid_key(door, "web_application_firewall_policy_link_id")

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_frontdoor",
		"resourceName": tf_lib.get_resource_name(door, name),
		"searchKey": sprintf("azurerm_frontdoor[%s].frontend_endpoint", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_frontdoor[%s].frontend_endpoint.web_application_firewall_policy_link_id' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_frontdoor[%s].frontend_endpoint.web_application_firewall_policy_link_id' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_frontdoor", name, "frontend_endpoint"], []),
	}
}
