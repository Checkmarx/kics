package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	vpnGateway := input.document[i].resource.nifcloud_vpn_gateway[name]
	not common_lib.valid_key(vpnGateway, "security_group")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_vpn_gateway",
		"resourceName": tf_lib.get_resource_name(vpnGateway, name),
		"searchKey": sprintf("nifcloud_vpn_gateway[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'nifcloud_vpn_gateway[%s]' should include a security_group for security purposes.", [name]),
		"keyActualValue": sprintf("'nifcloud_vpn_gateway[%s]' does not have a security_group defined.", [name]),
	}
}
