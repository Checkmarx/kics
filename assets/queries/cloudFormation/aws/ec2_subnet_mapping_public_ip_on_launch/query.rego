package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::Subnet"
	resource.Properties.MapPublicIpOnLaunch == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.MapPublicIpOnLaunch", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.MapPublicIpOnLaunch' should be false", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.MapPublicIpOnLaunch' is true", [name]),
	}
}
