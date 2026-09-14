package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_secret_manager_secret[name]
	replication := object.get(resource, "replication", {})
	not has_cmek(replication)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_secret_manager_secret",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_secret_manager_secret[%s].replication", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_secret_manager_secret[%s]' should configure customer_managed_encryption with a KMS key", [name]),
		"keyActualValue": sprintf("'google_secret_manager_secret[%s]' uses Google-managed encryption keys", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_secret_manager_secret", name, "replication"], []),
		"remediation": "replication {\n    user_managed {\n      replicas {\n        location = \"us-central1\"\n        customer_managed_encryption {\n          kms_key_name = google_kms_crypto_key.example.id\n        }\n      }\n    }\n  }",
		"remediationType": "replacement",
	}
}

has_cmek(replication) {
	is_object(replication.user_managed)
	replication.user_managed.replicas[_].customer_managed_encryption.kms_key_name != ""
}

has_cmek(replication) {
	is_array(replication.user_managed.replicas)
	replication.user_managed.replicas[_].customer_managed_encryption.kms_key_name != ""
}
