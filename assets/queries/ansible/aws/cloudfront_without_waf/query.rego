package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	redshiftCluster := task["community.aws.cloudfront_distribution"]

	not redshiftCluster.web_acl_id

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.cloudfront_distribution}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'web_acl_id' exists",
		"keyActualValue": "'web_acl_id' is missing",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
