package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront_distribution := task[modules[m]]
	ansLib.checkState(cloudfront_distribution)
	fields := ["default_cache_behavior", "cache_behaviors"]

	cloudfront_distribution[fields[f]].viewer_protocol_policy == "allow-all"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s.viewer_protocol_policy", [task.name, modules[m], fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("cloudfront_distribution.%s.viewer_protocol_policy should be 'https-only' or 'redirect-to-https'", [fields[f]]),
		"keyActualValue": sprintf("cloudfront_distribution.%s.viewer_protocol_policy isn't 'https-only' or 'redirect-to-https'", [fields[f]]),
	}
}
