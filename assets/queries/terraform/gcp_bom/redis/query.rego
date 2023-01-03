package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	redis := input.document[i].resource.google_redis_instance[name]

	bom_output = {
		"resource_type": "google_redis_instance",
		"resource_name": tf_lib.get_resource_name(redis, name),
		"resource_accessibility": check_accessability(redis),
		"resource_encryption": "encrypted",
		"resource_vendor": "GCP",
		"resource_category": "In Memory Data Structure",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_redis_instance[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name], []),
		"value": json.marshal(bom_output),
	}
}

check_accessability(redis_instance) = acc_status {
	common_lib.valid_key(redis_instance, "authorized_network")
	has_public_firewall(redis_instance.authorized_network)
	acc_status := "public"
} else = acc_status {
	acc_status := "unknown"
}

has_public_firewall(authorized_network){
	firewall := input.document[_].resource.google_compute_firewall[_]

	common_lib.is_ingress(firewall)
	common_lib.is_unrestricted(firewall.source_ranges[_])

	network_name := split(authorized_network, ".")[2]
	firewall_network := split(firewall.network, ".")[1]
	firewall_network == network_name
}
