package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

outdatedSSLPolicies := {
	"1",
	"2",
	"3",
	"5",
	"8",
}

CxPolicy[result] {
	some document in input.document
	lb := document.resource.nifcloud_load_balancer[name]
	not common_lib.valid_key(lb, "ssl_policy_id")

	result := {
		"documentId": document.id,
		"resourceType": "nifcloud_load_balancer",
		"resourceName": tf_lib.get_resource_name(lb, name),
		"searchKey": sprintf("nifcloud_load_balancer[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'nifcloud_load_balancer[%s]' should not use outdated/insecure TLS versions for encryption. You should be using TLS v1.2+.", [name]),
		"keyActualValue": sprintf("'nifcloud_load_balancer[%s]' using outdated SSL policy.", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	lb := document.resource.nifcloud_load_balancer[name]
	lb.ssl_policy_id == outdatedSSLPolicies[_]

	result := {
		"documentId": document.id,
		"resourceType": "nifcloud_load_balancer",
		"resourceName": tf_lib.get_resource_name(lb, name),
		"searchKey": sprintf("nifcloud_load_balancer[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_load_balancer[%s]' should not use outdated/insecure TLS versions for encryption. You should be using TLS v1.2+.", [name]),
		"keyActualValue": sprintf("'nifcloud_load_balancer[%s]' using outdated SSL policy.", [name]),
	}
}
