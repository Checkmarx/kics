package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront_distribution := task[modules[m]]
	ansLib.checkState(cloudfront_distribution)

	cloudfront_distribution.default_cache_behavior.viewer_protocol_policy == "allow-all"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.default_cache_behavior.viewer_protocol_policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudfront_distribution.default_cache_behavior.viewer_protocol_policy is 'https-only' or 'redirect-to-https'",
		"keyActualValue": "cloudfront_distribution.default_cache_behavior.viewer_protocol_policy isn't 'https-only' or 'redirect-to-https'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront_distribution := task[modules[m]]
	ansLib.checkState(cloudfront_distribution)

	cloudfront_distribution.cache_behaviors.viewer_protocol_policy == "allow-all"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.cache_behaviors.viewer_protocol_policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudfront_distribution.cache_behaviors.viewer_protocol_policy is 'https-only' or 'redirect-to-https'",
		"keyActualValue": "cloudfront_distribution.cache_behaviors.viewer_protocol_policy isn't 'https-only' or 'redirect-to-https'",
	}
}
