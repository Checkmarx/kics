package Cx

CxPolicy[result] {
	playbooks := getTasks(input.document[i])
	compute_instance := playbooks[j]
	instance := compute_instance["google.cloud.gcp_compute_instance"]
	metadata := instance.metadata

	object.get(metadata, "block-project-ssh-keys", "undefined") != "undefined"

	not isTrue(object.get(metadata, "block-project-ssh-keys", "undefined"))

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.metadata.block-project-ssh-keys", [playbooks[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.block-project-ssh-keys' is true", [playbooks[j].name]),
		"keyActualValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.block-project-ssh-keys' is false", [playbooks[j].name]),
	}
}

CxPolicy[result] {
	playbooks := getTasks(input.document[i])
	compute_instance := playbooks[j]
	instance := compute_instance["google.cloud.gcp_compute_instance"]
	metadata := instance.metadata

	object.get(metadata, "block-project-ssh-keys", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.metadata", [playbooks[j].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.block-project-ssh-keys' is set and is true", [playbooks[j].name]),
		"keyActualValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.block-project-ssh-keys' is undefined", [playbooks[j].name]),
	}
}

CxPolicy[result] {
	playbooks := getTasks(input.document[i])
	compute_instance := playbooks[j]
	instance := compute_instance["google.cloud.gcp_compute_instance"]

	object.get(instance, "metadata", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}", [playbooks[j].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata' is set", [playbooks[j].name]),
		"keyActualValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata' is undefined", [playbooks[j].name]),
	}
}

isTrue(attribute) {
	attribute == "yes"
} else {
	attribute == true
} else = false {
	true
}

getTasks(document) = result {
	result := document.playbooks[0].tasks
} else = result {
	object.get(document.playbooks[0], "tasks", "undefined") == "undefined"
	result := document.playbooks
}
