package Cx

CxPolicy[result] {
	awsGuardDuty := input.document[i].resource.aws_guardduty_detector[name]
	detector := awsGuardDuty.enable

	detector == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_guardduty_detector",
		"resourceName": name,
		"searchKey": sprintf("aws_guardduty_detector[%s].enable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "GuardDuty Detector should be Enabled",
		"keyActualValue": "GuardDuty Detector is not Enabled",
	}
}
