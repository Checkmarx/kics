package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

supported_mysql_engines := {"5.6", "5.7", "8"}
supported_sql_engines := { "08r2_ent_ha", "2012_ent_ha", "2016_ent_ha", "2017_ent", "2019_std_ha", "2019_ent"}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	resource.engine == "MySQL"
	resource.engine_version == supported_mysql_engines[_]  
	resource.tde_status == "Disabled"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_db_instance[%s].tde_status", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'tde_status' value should be 'Enabled'",
		"keyActualValue": "'tde_status' value is set to 'Disabled'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name, "tde_status"], []),
		"remediation": json.marshal({
            "before": "Disabled",
            "after": "Enabled"
        }),
        "remediationType": "replacement",	
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	resource.engine == "MySQL"
	resource.engine_version == supported_mysql_engines[_]  
	not common_lib.valid_key(resource,"tde_status")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'tde_status' value should be 'Enabled'",
		"keyActualValue": "'tde_status' is not declared",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name], []),
		"remediation": "tde_status = \"Enabled\"",
        "remediationType": "addition",	
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	resource.engine == "SQLServer"
	resource.engine_version == supported_sql_engines[_]  
	resource.tde_status == "Disabled"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_db_instance[%s].tde_status", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'tde_status' value should be 'Enabled'",
		"keyActualValue": "'tde_status' value is set to 'Disabled'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name, "tde_status"], []),
		"remediation": json.marshal({
            "before": "Disabled",
            "after": "Enabled"
        }),
        "remediationType": "replacement",
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_db_instance[name]
	resource.engine == "SQLServer"
	resource.engine_version == supported_sql_engines[_]  
	not common_lib.valid_key(resource,"tde_status")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'tde_status' value should be 'Enabled'",
		"keyActualValue": "'tde_status' is not declared",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name], []),
		"remediation": "tde_status = \"Enabled\"",
        "remediationType": "addition",	
	}
}


