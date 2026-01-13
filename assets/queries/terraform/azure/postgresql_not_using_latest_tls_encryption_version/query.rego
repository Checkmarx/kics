package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_server[name]

    common_lib.valid_key(resource, "ssl_minimal_tls_version_enforced")
    resource.ssl_minimal_tls_version_enforced != "TLS1_2"
    tls_version_val := resource.ssl_minimal_tls_version_enforced

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_postgresql_server[%s].minimum_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ssl_minimal_tls_version_enforced' should be defined to 'TLS1_2'",
		"keyActualValue": sprintf("'ssl_minimal_tls_version_enforced' is defined to '%s'", [tls_version_val]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_postgresql_server", name, "ssl_minimal_tls_version_enforced"], []),
		"remediation": json.marshal({
			"before": tls_version_val,
			"after": "TLS1_2",
		}),
		"remediationType": "replacement",
	}
}