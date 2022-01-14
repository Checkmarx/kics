package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::AutoScaling::LaunchConfiguration"
	prop := resource.Properties
	userData := prop.UserData

    contains(userData,"LS0tLS1CR")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.UserData", [name]),
		"issueType": "IncorrectValue", 
		"keyExpectedValue": sprintf("'Resources.%s.Properties.UserData' doesn't contain RSA Private Key", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.UserData' contains RSA Private Key", [name]),
	}
}
