package Cx

import data.generic.common as common_lib

logs_list = {
	"actiontrail_enabled", "actiontrail_ti_enabled",
	"oss_access_enabled", "oss_access_ti_enabled", "oss_metering_enabled",
	"rds_enabled", 
	"rds_ti_enabled", "rds_slow_enabled", "rds_perf_enabled",
	"vpc_flow_enabled",
	"polardb_enabled", "polardb_ti_enabled", "polardb_slow_enabled", "polardb_perf_enabled",
	"drds_audit_enabled", "drds_audit_ti_enabled",
	"slb_access_enabled", "slb_access_ti_enabled",
	"bastion_enabled", "bastion_ti_enabled",
	"waf_enabled", "waf_ti_enabled",
	"cloudfirewall_enabled", "cloudfirewall_ti_enabled",
	"ddos_coo_access_enabled", "ddos_coo_access_ti_enabled", "ddos_bgp_access_enabled", "ddos_dip_access_enabled",
		"ddos_dip_access_ti_enabled",
	"sas_process_enabled", "sas_network_enabled", "sas_login_enabled", "sas_crack_enabled", "sas_snapshot_process_enabled",
		"sas_snapshot_account_enabled", "sas_snapshot_port_enabled", "sas_dns_enabled", "sas_local_dns_enabled", "sas_session_enabled",
		"sas_http_enabled", "sas_security_vul_enabled", "sas_security_hc_enabled", "sas_security_alert_enabled", "sas_ti_enabled",
	"apigateway_enabled", "apigateway_ti_enabled",
	"nas_enabled", "nas_ti_enabled",
	"appconnect_enabled", "appconnect_ti_enabled",
	"cps_enabled", "cps_ti_enabled",
	"k8s_audit_enabled", "k8s_event_enabled", "k8s_ingress_enabled"
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_log_audit[name]
	variable_map := resource.variable_map
	log := logs_list[_]
	not common_lib.valid_key(variable_map, log)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_log_audit[%s].variable_map", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' parameter value should be 'true'", [log]),
		"keyActualValue": sprintf("'%s' parameter is not defined", [log]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_log_audit", name, "variable_map"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_log_audit[name]
	variable_map := resource.variable_map
	variable_map[log] == "false"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_log_audit[%s].variable_map.%s", [name, log]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' parameter value should be 'true'", [log]),
		"keyActualValue": sprintf("'%s' parameter value is 'false'", [log]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_log_audit", name, "variable_map", log], []),
	}
}

