package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}
	cloudfront_distribution := task[modules[m]]
	ansLib.checkState(cloudfront_distribution)

	ansLib.isAnsibleFalse(cloudfront_distribution.viewer_certificate.cloudfront_default_certificate)
	not checkMinPortocolVersion(cloudfront_distribution.viewer_certificate.minimum_protocol_version)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.viewer_certificate.minimum_protocol_version", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudfront_distribution.viewer_certificate.minimum_protocol_version should be TLSv1.1 or TLSv1.2",
		"keyActualValue": "cloudfront_distribution.viewer_certificate.minimum_protocol_version isn't TLSv1.1 or TLSv1.2",
	}
}

checkMinPortocolVersion("TLSv1.1") = true

checkMinPortocolVersion("TLSv1.2") = true
