package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	kmsPolicy := doc.resource.google_kms_crypto_key_iam_policy[name]

	policyName := split(kmsPolicy.policy_data, ".")[2]

	publicly_accessible(policyName)

	result := {
		"documentId": doc.id,
		"resourceType": "google_kms_crypto_key_iam_policy",
		"resourceName": tf_lib.get_resource_name(kmsPolicy, name),
		"searchKey": sprintf("google_kms_crypto_key_iam_policy[%s].policy_data", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "KMS crypto key should not be publicly accessible",
		"keyActualValue": "KMS crypto key is publicly accessible",
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key_iam_policy", name, "policy_data"], []),
	}
}

publicly_accessible(policyName) {
	policy := input.document[_].data.google_iam_policy[policyName]

	options := {"allUsers", "allAuthenticatedUsers"}
	check_member(policy.binding, options[_])
}

check_member(attribute, search) {
	search in attribute.members
} else {
	attribute.member == search
}
