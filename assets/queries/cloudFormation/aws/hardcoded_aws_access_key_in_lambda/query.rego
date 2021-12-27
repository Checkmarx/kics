package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::Lambda::Function"
	properties := resource.Properties

	envVars := properties.Environment.Variables
	regexAccessKey := ["[A-Za-z0-9/+=]{40}", "[A-Z0-9]{20}"]
	some var
	re_match(regexAccessKey[_], envVars[var])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Environment.Variables", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Environment.Variables doesn't contain access key", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.Environment.Variables contains access key", [key]),
	}
}
