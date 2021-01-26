package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	gcpTopic := task["google.cloud.gcp_kms_crypto_key"]
	gcpTopicName := task.name
	object.get(gcpTopic, "rotation_period", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_kms_crypto_key}}", [gcpTopicName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_kms_key_ring.rotation_period should be defined",
		"keyActualValue": "google.cloud.gcp_kms_key_ring.rotation_period is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	gcpTopic := task["google.cloud.gcp_kms_crypto_key"]
	gcpTopicName := task.name
	rotationP := substring(gcpTopic.rotation_period, 0, count(gcpTopic.rotation_period) - 1)
	to_number(rotationP) < 7776000

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_kms_crypto_key}}.rotation_period", [gcpTopicName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google.cloud.gcp_kms_key_ring.rotation_period should be >= 7776000",
		"keyActualValue": "google.cloud.gcp_kms_key_ring.rotation_period is < 7776000",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
