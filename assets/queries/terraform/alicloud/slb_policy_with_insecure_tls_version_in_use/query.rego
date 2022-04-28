package Cx

import data.generic.common as common_lib

insecureVersions := {"TLSv1.0", "TLSv1.1"}

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_slb_tls_cipher_policy[name]
	tls_version := insecureVersions[_]
	resource.tls_versions[_] == tls_version

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_slb_tls_cipher_policy[%s].tls_versions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_slb_tls_cipher_policy[%s].tls_versions uses secure TLS versions", [name]),
		"keyActualValue": sprintf("alicloud_slb_tls_cipher_policy[%s].tls_versions uses insecure TLS versions", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_slb_tls_cipher_policy", name, "tls_versions"], []),
	}
}
