package Cx

CxPolicy[result] {
	playbooks := getTasks(input.document[i])
	compute_instance := playbooks[j]
	instance := compute_instance["google.cloud.gcp_compute_instance"]
	metadata := instance.metadata

	isTrue(object.get(metadata, "serial-port-enable", "undefined"))

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.metadata.serial-port-enable", [playbooks[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.serial-port-enable' is undefined or set to false", [playbooks[j].name]),
		"keyActualValue": sprintf("'name=%s.{{google.cloud.gcp_compute_instance}}.metadata.serial-port-enable' is set to true", [playbooks[j].name]),
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
