package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]

	image_type := task["google.cloud.gcp_container_node_pool"].config.image_type
	lower(image_type) != "cos"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_container_node_pool}}.config.image_type", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'config.image_type' is equal to 'COS'",
		"keyActualValue": "'config.image_type' is not equal to 'COS'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
