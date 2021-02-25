package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfrontDistribution := task["community.aws.cloudfront_distribution"]

	cloudfrontDistribution.default_cache_behavior.viewer_protocol_policy = "allow-all"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'default_cache_behavior.viewer_protocol_policy' is equal to 'https-only' or 'redirect-to-https'",
		"keyActualValue": "'default_cache_behavior.viewer_protocol_policy' is equal 'allow-all'",
	}
}
