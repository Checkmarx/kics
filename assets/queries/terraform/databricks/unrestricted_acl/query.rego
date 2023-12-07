package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.databricks_ip_access_list[name]

	some j
	isEntireNetwork(resource.ip_addresses[j])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "databricks_ip_access_list",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("databricks_ip_access_list[%s].ip_addresses", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'databricks_ip_access_list[%s].ip_addresses' should not be equal to '0.0.0.0/0' or '::/0'", [name]),
		"keyActualValue": sprintf("'databricks_ip_access_list[%s].ip_addresses' is equal to '0.0.0.0/0' or '::/0'", [name]),
	}
}

isEntireNetwork(cidr) {
	is_string(cidr)
	cidrs = {"0.0.0.0/0", "::/0"}
	cidr == cidrs[j]
}
