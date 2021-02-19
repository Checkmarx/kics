package Cx

CxPolicy[result] {
	compute := input.document[i].resource.google_compute_instance[name]
	metadata := compute.metadata
	ssh_keys_enabled := object.get(metadata, "block-project-ssh-keys", "undefined")
    ssh_keys_enabled != "undefined"
	not isTrue(ssh_keys_enabled)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s].metadata.block-project-ssh-keys", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_instance[%s].metadata.block-project-ssh-keys is true", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].metadata.block-project-ssh-keys is %s", [name, ssh_keys_enabled]),
	}
}

CxPolicy[result] {
	compute := input.document[i].resource.google_compute_instance[name]
	object.get(compute,"metadata","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_compute_instance[%s].metadata is set", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].metadata is undefined", [name]),
	}
}

CxPolicy[result] {
	compute := input.document[i].resource.google_compute_instance[name]
	object.get(compute.metadata,"block-project-ssh-keys","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_instance[%s].metadata", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_compute_instance[%s].metadata.block-project-ssh-keys is set", [name]),
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
