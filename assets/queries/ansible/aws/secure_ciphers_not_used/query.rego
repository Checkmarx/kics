package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront_distribution := task["community.aws.cloudfront_distribution"]

	ansLib.isAnsibleFalse(cloudfront_distribution.viewer_certificate.cloudfront_default_certificate)
	not checkMinPortocolVersion(cloudfront_distribution.viewer_certificate.minimum_protocol_version)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.viewer_certificate.minimum_protocol_version", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.viewer_certificate.minimum_protocol_version is TLSv1.1 or TLSv1.2", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.viewer_certificate.minimum_protocol_version isn't TLSv1.1 or TLSv1.2", [task.name]),
	}
}

checkMinPortocolVersion("TLSv1.1") = true

checkMinPortocolVersion("TLSv1.2") = true
