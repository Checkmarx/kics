package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}
	cloudfront := task[modules[m]]

	ansLib.checkState(cloudfront)
	certificate := cloudfront.viewer_certificate.cloudfront_default_certificate
	ansLib.isAnsibleTrue(certificate)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.viewer_certificate.cloudfront_default_certificate", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'cloudfront_default_certificate' is 'false' or not defined",
		"keyActualValue": "Attribute 'cloudfront_default_certificate' is 'true'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}
	cloudfront := task[modules[m]]

	ansLib.checkState(cloudfront)
	hasCustomConfig(cloudfront.viewer_certificate)

	attr := {"ssl_support_method", "minimum_protocol_version"}
	object.get(cloudfront.viewer_certificate, attr[a], "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.viewer_certificate", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Attribute %s is defined when one of 'acm_certificate_arn' or 'iam_certificate_id' is declared.", [attr[a]]),
		"keyActualValue": sprintf("Attribute '%s' is not defined", [attr[a]]),
	}
}

hasCustomConfig(viewer_certificate) {
	object.get(viewer_certificate, "acm_certificate_arn", "undefined") != "undefined"
}

hasCustomConfig(viewer_certificate) {
	object.get(viewer_certificate, "iam_certificate_id", "undefined") != "undefined"
}
