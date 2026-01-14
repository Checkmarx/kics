package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    supported_resources := {"azurerm_linux_function_app_slot", "azurerm_windows_function_app_slot"}
    resource := input.document[i].resource[supported_resources[resource_index]][name]

    common_lib.valid_key(resource.site_config, "minimum_tls_version")
    resource.site_config.minimum_tls_version != "1.2"
    resource.site_config.minimum_tls_version != "1.3"
    tls_version_val := resource.site_config.minimum_tls_version

	result := {
		"documentId": input.document[i].id,
		"resourceType": supported_resources[resource_index],
		"resourceName": tf_lib.get_resource_name(resource,name),
		"searchKey": sprintf("%s[%s].site_config.minimum_tls_version", [supported_resources[resource_index], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'site_config.minimum_tls_version' should be defined to '1.2' or higher",
		"keyActualValue": sprintf("'site_config.minimum_tls_version' is defined to '%s'", [tls_version_val]),
		"searchLine": common_lib.build_search_line(["resource", supported_resources[resource_index], name, "site_config", "minimum_tls_version"], []),
		"remediation": json.marshal({
			"before": tls_version_val,
			"after": "1.3",
		}),
		"remediationType": "replacement",
	}
}