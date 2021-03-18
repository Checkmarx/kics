package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::GuardDuty::Detector"
	properties := resource.Properties
	properties.Enable == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Enable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "GuardDuty Detector should be Enabled",
		"keyActualValue": "GuardDuty Detector is not Enabled",
	}
}
