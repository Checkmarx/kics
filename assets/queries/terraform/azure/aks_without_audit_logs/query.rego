package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	diagnostic_settings := {doc_index : x | x := input.document[doc_index].resource.azurerm_monitor_diagnostic_setting}
	resource := input.document[doc_i].resource.azurerm_kubernetes_cluster[name]

	not at_least_one_enabled_log(diagnostic_settings, name)

	result := get_results(diagnostic_settings, name, resource, doc_i)[_]
}

get_results(diagnostic_settings, resource_name, resource, doc_i) = results {
	results := [x | x := {
		"documentId": input.document[doc_index].id,
		"resourceType" : "azurerm_monitor_diagnostic_setting",
		"resourceName" : tf_lib.get_resource_name(diagnostic_settings[doc_index][name], name),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].log.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s]' should enable audit logging through a 'azurerm_monitor_diagnostic_setting'", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s]' has the 'enabled' field set to '%s' instead of 'true'", [name, diagnostic_settings[doc_index][name].log.enabled]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name, "log", "enabled"], [])
	}
	targets_resource(diagnostic_settings[doc_index][name], resource_name)
	contains(diagnostic_settings[doc_index][name].log.category, "kube-audit")			# "log" object  (legacy)
    diagnostic_settings[doc_index][name].log.enabled != true]
    results != []
} else = results {
	results := [x | x := {
		"documentId": input.document[doc_index].id,
		"resourceType" : "azurerm_monitor_diagnostic_setting",
		"resourceName" : tf_lib.get_resource_name(diagnostic_settings[doc_index][name], name),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].log[%d].enabled", [name, index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s]' should enable audit logging through a 'azurerm_monitor_diagnostic_setting'", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s]' has the 'enabled' field set to '%s' instead of 'true'", [name, diagnostic_settings[doc_index][name].log[index].enabled]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name, "log", index, "enabled"], [])
	}
	targets_resource(diagnostic_settings[doc_index][name], resource_name)
    contains(diagnostic_settings[doc_index][name].log[index].category, "kube-audit")
    diagnostic_settings[doc_index][name].log[index].enabled != true] 					# "log" array  (legacy)
    results != []
} else = results {
	results := [x | x := {
		"documentId": input.document[doc_index].id,
		"resourceType": "azurerm_monitor_diagnostic_setting",
		"resourceName": tf_lib.get_resource_name(diagnostic_settings[doc_index][name], name),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].log.category", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log.category' should be defined to 'kube-audit' or 'kube-audit-admin' and 'enabled' field set to 'true'", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log.category' is not defined to 'kube-audit' or 'kube-audit-admin'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name, "log", "category"], [])
	}
	targets_resource(diagnostic_settings[doc_index][name], resource_name)
	not contains(diagnostic_settings[doc_index][name].log.category, "kube-audit") # "log" object with wrong category (legacy)
	]
	results != []
} else = results {
	results := [x | x := {
		"documentId": input.document[doc_index].id,
		"resourceType": "azurerm_monitor_diagnostic_setting",
		"resourceName": tf_lib.get_resource_name(diagnostic_settings[doc_index][name], name),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].log[%d].category", [name, index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log[%d].category' should be defined to 'kube-audit' or 'kube-audit-admin' and 'enabled' field set to 'true'", [name, index]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log[%d].category' is not defined to 'kube-audit' or 'kube-audit-admin'", [name, index]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name, "log", index, "category"], [])
	}
	targets_resource(diagnostic_settings[doc_index][name], resource_name)
	log_content := diagnostic_settings[doc_index][name].log[index]
	not contains(log_content.category, "kube-audit") # "log" array with wrong category (legacy)
	]
	results != []
} else = results {
	results := [x | x := {
		"documentId": input.document[doc_index].id,
		"resourceType": "azurerm_monitor_diagnostic_setting",
		"resourceName": tf_lib.get_resource_name(diagnostic_settings[doc_index][name], name),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].enabled_log[%d].category", [name, index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].enabled_log[%d].category' should be defined to 'kube-audit' or 'kube-audit-admin'", [name, index]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].enabled_log[%d].category' is not defined to 'kube-audit' or 'kube-audit-admin'", [name, index]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name, "enabled_log", index, "category"], [])
	}
	targets_resource(diagnostic_settings[doc_index][name], resource_name)
	enabled_log_content := diagnostic_settings[doc_index][name].enabled_log[index]
	not contains(enabled_log_content.category, "kube-audit") # "enabled_log"  array with wrong category
	]
	results != []
} else = results {
	results := [x | x := {
		"documentId": input.document[doc_index].id,
		"resourceType": "azurerm_monitor_diagnostic_setting",
		"resourceName": tf_lib.get_resource_name(diagnostic_settings[doc_index][name], name),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].enabled_log.category", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].enabled_log.category' should be defined to 'kube-audit' or 'kube-audit-admin'", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].enabled_log.category' is not defined to 'kube-audit' or 'kube-audit-admin'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name, "enabled_log", "category"], [])
	}
	targets_resource(diagnostic_settings[doc_index][name], resource_name)
	not contains(diagnostic_settings[doc_index][name].enabled_log.category, "kube-audit") # "enabled_log"  object with wrong category
	]
	results != []
} else = results  {
	results := [x | x := {
		"documentId": input.document[doc_i].id,
		"resourceType" : "azurerm_kubernetes_cluster",
		"resourceName" : tf_lib.get_resource_name(resource, resource_name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [resource_name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s]' should enable audit logging through a 'azurerm_monitor_diagnostic_setting'", [resource_name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s]' does not enable audit logging", [resource_name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", resource_name], [])
	}]
}

at_least_one_enabled_log(diagnostic_settings, resource_name) {
	has_valid_enabled_log(diagnostic_settings[_][_], resource_name)
}

has_valid_enabled_log(diagnostic_setting, resource_name) {
	targets_resource(diagnostic_setting, resource_name)
	contains(diagnostic_setting.enabled_log[_].category, "kube-audit")	# kube-audit or kube-audit-admin - array
} else {
	targets_resource(diagnostic_setting, resource_name)
	contains(diagnostic_setting.enabled_log.category, "kube-audit")	# kube-audit or kube-audit-admin - object
} else {
	targets_resource(diagnostic_setting, resource_name)
	contains(diagnostic_setting.log[index].category, "kube-audit")	# kube-audit or kube-audit-admin - "log" array  (legacy)
	diagnostic_setting.log[index].enabled == true
} else {
	targets_resource(diagnostic_setting, resource_name)
	contains(diagnostic_setting.log.category, "kube-audit")		    # kube-audit or kube-audit-admin - "log" object  (legacy)
	diagnostic_setting.log.enabled == true
}

targets_resource(diagnostic_setting, resource_name) {
	diagnostic_setting.target_resource_id == sprintf("${azurerm_kubernetes_cluster.%s.id}",[resource_name])
}
