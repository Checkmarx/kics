package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

outdatedSSLPolicies := {
	"Standard Ciphers A ver1",
	"Standard Ciphers B ver1",
	"Standard Ciphers C ver1",
	"Ats Ciphers A ver1",
	"Ats Ciphers D ver1"
}

CxPolicy[result] {

	lb := input.document[i].resource.nifcloud_load_balancer[name]
	not common_lib.valid_key(lb, "ssl_policy_name")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_load_balancer",
		"resourceName": tf_lib.get_resource_name(lb, name),
		"searchKey": sprintf("nifcloud_load_balancer[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'nifcloud_load_balancer[%s]' should not use outdated/insecure TLS versions for encryption. You should be using TLS v1.2+.", [name]),
		"keyActualValue": sprintf("'nifcloud_load_balancer[%s]' using outdated SSL policy.", [name]),
	}
}

CxPolicy[result] {

	lb := input.document[i].resource.nifcloud_load_balancer[name]
	lb.ssl_policy_name == outdatedSSLPolicies[_]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_load_balancer",
		"resourceName": tf_lib.get_resource_name(lb, name),
		"searchKey": sprintf("nifcloud_load_balancer[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_load_balancer[%s]' should not use outdated/insecure TLS versions for encryption. You should be using TLS v1.2+.", [name]),
		"keyActualValue": sprintf("'nifcloud_load_balancer[%s]' using outdated SSL policy.", [name]),
	}
}
