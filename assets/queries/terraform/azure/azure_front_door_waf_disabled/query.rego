package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	door := input.document[i].resource.azurerm_frontdoor[name].frontend_endpoint

	not common_lib.valid_key(door, "web_application_firewall_policy_link_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_frontdoor[%s].frontend_endpoint", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_frontdoor[%s].frontend_endpoint.web_application_firewall_policy_link_id' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_frontdoor[%s].frontend_endpoint.web_application_firewall_policy_link_id' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_frontdoor", name, "frontend_endpoint"], []),
	}
}
