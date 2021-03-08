package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}
	redshiftCluster := task[modules[m]]
	ansLib.checkState(redshiftCluster)

	not redshiftCluster.web_acl_id

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudfront_distribution.web_acl_id is defined",
		"keyActualValue": "cloudfront_distribution.web_acl_id is undefined",
	}
}
