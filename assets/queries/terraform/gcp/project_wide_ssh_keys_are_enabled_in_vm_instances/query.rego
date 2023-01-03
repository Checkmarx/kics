package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	compute := input.document[i].resource.google_compute_instance[name]
	metadata := compute.metadata
	ssh_keys_enabled := metadata["block-project-ssh-keys"]
	not isTrue(ssh_keys_enabled)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(compute, name),
		"searchKey": sprintf("google_compute_instance[%s].metadata.block-project-ssh-keys", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_instance[%s].metadata.block-project-ssh-keys should be true", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].metadata.block-project-ssh-keys is %s", [name, ssh_keys_enabled]),
	}
}

CxPolicy[result] {
	compute := input.document[i].resource.google_compute_instance[name]
	not common_lib.valid_key(compute,"metadata")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(compute, name),
		"searchKey": sprintf("google_compute_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_compute_instance[%s].metadata should be set", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].metadata is undefined", [name]),
	}
}

CxPolicy[result] {
	compute := input.document[i].resource.google_compute_instance[name]
	not common_lib.valid_key(compute.metadata,"block-project-ssh-keys")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(compute, name),
		"searchKey": sprintf("google_compute_instance[%s].metadata", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_compute_instance[%s].metadata.block-project-ssh-keys should be set", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].metadata.block-project-ssh-keys is undefined", [name]),
	}
}

isTrue(ssh_keys_enabled) {
	is_string(ssh_keys_enabled)
	lower(ssh_keys_enabled) == "true"
}

isTrue(ssh_keys_enabled) {
	is_boolean(ssh_keys_enabled)
	ssh_keys_enabled
}
