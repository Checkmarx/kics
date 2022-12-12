package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	cloudfront := task[modules[m]]

	ans_lib.checkState(cloudfront)
	not common_lib.valid_key(cloudfront, "viewer_certificate")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudfront_distribution.viewer_certificate should be defined",
		"keyActualValue": "cloudfront_distribution.viewer_certificate is undefined",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m]], []),
	}
}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	cloudfront := task[modules[m]]

	ans_lib.checkState(cloudfront)
	protocol_version := cloudfront.viewer_certificate.minimum_protocol_version

	not common_lib.is_recommended_tls(protocol_version)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.viewer_certificate.minimum_protocol_version", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.viewer_certificate.minimum_protocol_version' should be TLSv1.2_x", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.viewer_certificate.minimum_protocol_version' is %s", [task.name, modules[m], protocol_version]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "viewer_certificate", "minimum_protocol_version"], []),
	}
}
