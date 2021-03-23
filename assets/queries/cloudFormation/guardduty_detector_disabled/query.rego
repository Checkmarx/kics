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
		"keyExpectedValue": sprintf("Resources.%s.Properties.Enable is set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Enable is set to false", [name]),
	}
}
