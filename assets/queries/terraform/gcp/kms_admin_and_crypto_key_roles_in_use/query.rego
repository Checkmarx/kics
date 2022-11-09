package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_project_iam_policy[name]

	policyName := split(resource.policy_data,".")[2]
	policy := input.document[_].data.google_iam_policy[policyName]

    count({x | binding = policy.binding[x]; binding.role == "roles/cloudkms.admin"; has_cryptokey_roles_in_use(policy, binding.members)}) != 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_iam_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_project_iam_policy[%s].policy_data", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_iam_policy[%s].policy_data should not assign a KMS admin role and CryptoKey role to the same member", [name]),
		"keyActualValue": sprintf("google_iam_policy[%s].policy_data assigns a KMS admin role and CryptoKey role to the same member", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_project_iam_policy", name, "policy_data"], []),
	}
}


has_cryptokey_roles_in_use(policy, targetMembers) {
	roles := {"roles/cloudkms.cryptoKeyDecrypter", "roles/cloudkms.cryptoKeyEncrypter", "roles/cloudkms.cryptoKeyEncrypterDecrypter"}
	binding := policy.binding[_]
    binding.role == roles[_]
    binding.members[_] == targetMembers[_]
}
