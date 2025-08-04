package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	results_0 := get_ip_configuration(resource,name)
	results_0 != ""
	ip_configuration_raw := results_0.ip_configuration
	
	ip_configuration := account_for_dynamic(ip_configuration_raw)

	authorized_networks = ip_configuration.authorized_networks

	results := dynamic_contains(authorized_networks, "0.0.0.0",name) 
	results != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.authorized_networks.value=%s", [name ,results.value]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'authorized_network' address should be trusted",
		"keyActualValue": "'authorized_network' address is not restricted: '0.0.0.0/0'",
		"searchLine": results.searchLine
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	results := get_ip_configuration(resource,name) 
	results != ""
	ip_configuration := results.ip_configuration

	no_authorized_networks(ip_configuration,name)

	searchLine := array.concat(results.searchLine,["ipv4_enabled"])

	ip_configuration.ipv4_enabled

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.ipv4_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ipv4_enabled' should be disabled and 'private_network' should be defined when there are no authorized networks",
		"keyActualValue": "'ipv4_enabled' is enabled when there are no authorized networks",
		"searchLine": common_lib.build_search_line(searchLine ,[])
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	results := get_ip_configuration(resource,name) 
	results != ""

	ip_configuration := results.ip_configuration

	no_authorized_networks(ip_configuration,name)

	not ip_configuration.ipv4_enabled
	not common_lib.valid_key(ip_configuration,"private_network")


	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ipv4_enabled' should be disabled and 'private_network' should be defined when there are no authorized networks",
		"keyActualValue": "'private_network' is not defined when there are no authorized networks",
		"searchLine": common_lib.build_search_line(results.searchLine,[])
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]

	ip_configuration := get_ip_configuration(resource,name)   
	ip_configuration == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ip_configuration' should be defined and allow only trusted networks",
		"keyActualValue": "'ip_configuration' is not defined",
		"searchLine": common_lib.build_search_line(["resource","google_sql_database_instance",name,"settings"],[])
	}
}

get_ip_configuration(resource,name) = results {
	common_lib.valid_key(resource.settings.dynamic.ip_configuration,"content")
	ip_configuration := resource.settings.dynamic.ip_configuration.content
	results := {
		"ip_configuration" : ip_configuration,
		"searchLine": ["resource","google_sql_database_instance",name,"settings","dynamic","ip_configuration","content"]
	}
} else = results {
	common_lib.valid_key(resource.settings,"ip_configuration")
	ip_configuration := resource.settings.ip_configuration
	results := {
		"ip_configuration" : ip_configuration,
		"searchLine" : ["resource","google_sql_database_instance",name,"settings","ip_configuration"]
	}
} else = ""


no_authorized_networks(ip_configuration,name) = true {
    not common_lib.valid_key(ip_configuration,"authorized_networks")
	not common_lib.valid_key(ip_configuration,"dynamic")
} else = true {
	not common_lib.valid_key(ip_configuration,"authorized_networks")
	common_lib.valid_key(ip_configuration,"dynamic")
	not common_lib.valid_key(ip_configuration.dynamic,"authorized_networks")
} else = false


account_for_dynamic(ip_configuration) = adjusted_ip_config{
	common_lib.valid_key(ip_configuration,"dynamic")
	adjusted_ip_config := ip_configuration.dynamic
} else = adjusted_ip_config {
    adjusted_ip_config := ip_configuration
}


dynamic_contains(authorized_network,address,name) = response  {
	is_array(authorized_network)
	contains(authorized_network[index].value,address)
	response := {
		"value" : authorized_network[index].value,
		"searchLine": common_lib.build_search_line(["resource","google_sql_database_instance",name,"settings","ip_configuration","authorized_networks",index,"value"],[])
	}
} else = response {
	is_array(authorized_network)
	contains(authorized_network[index].content.value,address)
	response := {
		"value" : authorized_network[index].content.value,
		"searchLine": common_lib.build_search_line(["resource","google_sql_database_instance",name,"settings","dynamic","ip_configuration","content","dynamic","authorized_networks",index,"content","value"],[])
	}
} else = response {
	is_object(authorized_network)
	contains(authorized_network.value,address)
	response := {
		"value" : authorized_network.value,
		"searchLine": common_lib.build_search_line(["resource","google_sql_database_instance",name,"settings","ip_configuration","authorized_networks","value"],[])
	}
} else = response {
	is_object(authorized_network)
	contains(authorized_network.content.value,address)
	response := {
		"value" : authorized_network.content.value,
		"searchLine": common_lib.build_search_line(["resource","google_sql_database_instance",name,"settings","dynamic","ip_configuration","content","dynamic","authorized_networks","content","value"],[])
	}
} else = ""
