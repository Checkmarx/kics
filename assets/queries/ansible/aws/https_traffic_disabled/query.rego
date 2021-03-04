package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task["community.aws.cloudfront_distribution"].default_cache_behavior.viewer_protocol_policy == "allow-all"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy is 'https-only' or 'redirect-to-https'", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy 'isn't https-only' or 'redirect-to-https'", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task["community.aws.cloudfront_distribution"].cache_behaviors.viewer_protocol_policy == "allow-all"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.cache_behaviors.viewer_protocol_policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.cache_behaviors.viewer_protocol_policy is 'https-only' or 'redirect-to-https'", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.cache_behaviors.viewer_protocol_policy 'isn't https-only' or 'redirect-to-https'", [task.name]),
	}
}
