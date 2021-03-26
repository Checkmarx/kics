package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"community.aws.cloudfront_distribution", "cloudfront_distribution"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront := task[modules[m]]

	ansLib.checkState(cloudfront)
	object.get(cloudfront, "viewer_certificate", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudfront_distribution.viewer_certificate is defined",
		"keyActualValue": "cloudfront_distribution.viewer_certificate is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudfront := task[modules[m]]

	ansLib.checkState(cloudfront)
	protocol_version := cloudfront.viewer_certificate.minimum_protocol_version

	not commonLib.inArray(["TLSv1.2_2018", "TLSv1.2_2019"], protocol_version)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.viewer_certificate.minimum_protocol_version", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.viewer_certificate.minimum_protocol_version' is TLSv1.2_x", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.viewer_certificate.minimum_protocol_version' is %s", [task.name, modules[m], protocol_version]),
	}
}
