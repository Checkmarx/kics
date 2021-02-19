package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
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