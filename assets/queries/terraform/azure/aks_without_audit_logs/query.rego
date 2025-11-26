package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	diagnostic_settings := {x | x := input.document[_].resource.azurerm_monitor_diagnostic_setting[_]}
	resource := input.document[i].resource.azurerm_kubernetes_cluster[name]

	not diagnostic_for_resource(diagnostic_settings, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s]' should enable audit logging through a 'azurerm_monitor_diagnostic_setting'", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s]' does not enable audit logging", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name], [])
	}
}

diagnostic_for_resource(diagnostic_settings, resource_name) {
	diagnostic_settings[index].target_resource_id == sprintf("${azurerm_kubernetes_cluster.%s.id}",[resource_name])
	has_audit_logging(diagnostic_settings[index])
}

has_audit_logging(diagnositc_setting) {
	contains(diagnositc_setting.enabled_log[_].category, "kube-audit")	# kube-audit or kube-audit-admin - enabled_log array
} else {
	contains(diagnositc_setting.enabled_log.category, "kube-audit")		# kube-audit or kube-audit-admin - enabled_log object
} else {
	contains(diagnositc_setting.log[_].category, "kube-audit")	# kube-audit or kube-audit-admin - log array  (legacy)
} else {
	contains(diagnositc_setting.log.category, "kube-audit")		# kube-audit or kube-audit-admin - log object  (legacy)
}
