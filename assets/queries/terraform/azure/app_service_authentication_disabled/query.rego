package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

resources := {"azurerm_linux_web_app", "azurerm_windows_web_app"}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_app_service[name]

	not common_lib.valid_key(resource, "auth_settings")

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_app_service[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].auth_settings' should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].auth_settings' is undefined", [name]),
		"remediation": "auth_settings {\n\t\tenabled = true\n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_app_service[name]

	resource.auth_settings.enabled == false

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_app_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_app_service[%s].auth_settings.enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_app_service", name, "auth_settings", "enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_app_service[%s].auth_settings.enabled' should be true", [name]),
		"keyActualValue": sprintf("'azurerm_app_service[%s].auth_settings.enabled' is false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}


CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource[resources[t]][name]

	res := prepare_issues(resource, resources[t], name)

	result := {
		"documentId": doc.id,
		"resourceType": resources[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": res["sk"],
		"searchLine": res["sl"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"remediation": res["rem"],
		"remediationType": res["rt"],
	}
}

prepare_issues(resource, type, name) = res { # auth_settings and auth_settings_v2 not defined
	not common_lib.valid_key(resource, "auth_settings")
	not common_lib.valid_key(resource, "auth_settings_v2")
	res := {
		"sk": sprintf("%s[%s]", [type, name]),
		"sl": common_lib.build_search_line(["resource", type, name], []),
		"it": "MissingAttribute",
		"kev": sprintf("'%s[%s].auth_settings' or '%s[%s].auth_settings_v2' should be defined", [type, name, type, name]),
		"kav": sprintf("'%s[%s].auth_settings' and '%s[%s].auth_settings_v2' are not defined defined", [type, name, type, name]),
		"rem": "auth_settings {\n\t\tenabled = true\n\t}",
		"rt": "addition", 
	}
} else = res { # auth_settings field defined and auth_settings.enabled defined to false
	common_lib.valid_key(resource, "auth_settings")
	resource.auth_settings.enabled == false
	res := {
		"sk": sprintf("'%s[%s].auth_settings.enabled'", [type, name]),
		"sl": common_lib.build_search_line(["resource", type, name, "auth_settings", "enabled"], []),
		"it": "IncorrectValue",
		"kev": sprintf("'%s[%s].auth_settings.enabled' should be defined to 'true'", [type, name]),
		"kav": sprintf("'%s[%s].auth_settings.enabled' is defined to 'false'", [type, name]),
		"rem": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"rt": "replacement",
	}
} else = res { # auth_settings_v2 field defined with the field auth_enabled defined to false
	common_lib.valid_key(resource, "auth_settings_v2")
	common_lib.valid_key(resource.auth_settings_v2, "auth_enabled")
	resource.auth_settings_v2.auth_enabled == false 
	res := {
		"sk": sprintf("%s[%s].auth_settings_v2.auth_enabled", [type, name]),
		"sl": common_lib.build_search_line(["resource", type, name, "auth_settings_v2", "auth_enabled"], []),
		"it": "IncorrectValue",
		"kev": sprintf("'%s[%s].auth_settings_v2.auth_enabled' should be defined to 'true'", [type, name]),
		"kav": sprintf("'%s[%s].auth_settings_v2.auth_enabled' is defined to 'false'", [type, name]),
		"rem": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"rt": "replacement",
	}
} else = res { # auth_settings_v2 field defined but without the field auth_enabled defined
	common_lib.valid_key(resource, "auth_settings_v2")
	not common_lib.valid_key(resource.auth_settings_v2, "auth_enabled")
	res := {
		"sk": sprintf("%s[%s].auth_settings_v2", [type, name]),
		"sl": common_lib.build_search_line(["resource", type, name, "auth_settings_v2"], []),
		"it": "MissingAttribute",
		"kev": sprintf("'%s[%s].auth_settings_v2.auth_enabled' should be defined (default value is 'false')", [type, name]),
		"kav": sprintf("'%s[%s].auth_settings_v2.auth_enabled' is not defined", [type, name]),
		"rem": "auth_enabled = true",
		"rt": "addition",
	}
} 