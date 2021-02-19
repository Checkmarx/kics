package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.cloudfront_distribution"].publicly_accessible)
	task["community.aws.cloudfront_distribution"].default_cache_behavior.viewer_protocol_policy == "allow-all"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy is 'https-only' or 'redirect-to-https'", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy 'isn't https-only' or 'redirect-to-https'", [task.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.cloudfront_distribution"].publicly_accessible)
	task["community.aws.cloudfront_distribution"].cache_behaviors.viewer_protocol_policy == "allow-all"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.cache_behaviors.viewer_protocol_policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.cache_behaviors.viewer_protocol_policy is 'https-only' or 'redirect-to-https'", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.cache_behaviors.viewer_protocol_policy 'isn't https-only' or 'redirect-to-https'", [task.name]),
	}
}