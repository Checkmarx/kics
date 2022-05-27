package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	awsGuardDuty := input.document[i].resource.aws_guardduty_detector[name]
	detector := awsGuardDuty.enable

	detector == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_guardduty_detector",
		"resourceName": tf_lib.get_resource_name(awsGuardDuty, name),
		"searchKey": sprintf("aws_guardduty_detector[%s].enable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "GuardDuty Detector should be Enabled",
		"keyActualValue": "GuardDuty Detector is not Enabled",
	}
}
