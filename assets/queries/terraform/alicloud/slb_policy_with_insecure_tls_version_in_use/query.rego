package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

insecureVersions := {"TLSv1.0", "TLSv1.1"}

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.alicloud_slb_tls_cipher_policy[name]
	some tls_version in insecureVersions
	tls_version in resource.tls_versions

	result := {
		"documentId": doc.id,
		"resourceType": "alicloud_slb_tls_cipher_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_slb_tls_cipher_policy[%s].tls_versions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_slb_tls_cipher_policy[%s].tls_versions to use secure TLS versions", [name]),
		"keyActualValue": sprintf("alicloud_slb_tls_cipher_policy[%s].tls_versions uses insecure TLS versions", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_slb_tls_cipher_policy", name, "tls_versions"], []),
	}
}
