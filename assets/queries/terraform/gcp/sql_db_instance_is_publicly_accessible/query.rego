package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration_raw := get_ip_configuration(resource)   
	ip_configuration_raw != ""
	
	ip_configuration := account_for_dynamic(ip_configuration_raw)

	authorized_network = getAuthorizedNetworks_list(ip_configuration.authorized_networks)

	address := dynamic_contains(authorized_network[j], "0.0.0.0") 
	address != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.authorized_networks.value=%s", [name ,address]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'authorized_network' address should be trusted",
		"keyActualValue": "'authorized_network' address is not restricted: '0.0.0.0/0'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration := get_ip_configuration(resource)   
	ip_configuration != ""

	no_authorized_networks(ip_configuration)

	ip_configuration.ipv4_enabled

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.ipv4_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ipv4_enabled' should be disabled and 'private_network' should be defined when there are no authorized networks",
		"keyActualValue": "'ipv4_enabled' is enabled when there are no authorized networks",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration := get_ip_configuration(resource)   
	ip_configuration != ""

	no_authorized_networks(ip_configuration)

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
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]

	ip_configuration := get_ip_configuration(resource)   
	ip_configuration == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ip_configuration' should be defined and allow only trusted networks",
		"keyActualValue": "'ip_configuration' is not defined",
	}
}

get_ip_configuration(resource) = ip_configuration {
	ip_configuration := resource.settings.ip_configuration
} else = ip_configuration {
	ip_configuration := resource.settings.dynamic.ip_configuration.content
} else = ""

no_authorized_networks(ip_configuration) = true {
    not common_lib.valid_key(ip_configuration,"authorized_networks")
	not common_lib.valid_key(ip_configuration,"dynamic")
} else = true {
	not common_lib.valid_key(ip_configuration,"authorized_networks")
	common_lib.valid_key(ip_configuration,"dynamic")
	not common_lib.valid_key(ip_configuration.dynamic,"authorized_networks")
} else = false


getAuthorizedNetworks_list(networks) = list {
    is_array(networks)
    list := networks
} else = list {
    is_object(networks)
    list := [networks]
} else = null


account_for_dynamic(ip_configuration) = adjusted_ip_config{
	common_lib.valid_key(ip_configuration,"dynamic")
	adjusted_ip_config := ip_configuration.dynamic
} else = adjusted_ip_config {
    adjusted_ip_config := ip_configuration
}

dynamic_contains(authorized_network,address) = authorized_network.value {
	contains(authorized_network.value,address)
} else = authorized_network.content.value {
	contains(authorized_network.content.value,address)
} else = ""
