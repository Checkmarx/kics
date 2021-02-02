package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::User"
	policies := resource.Properties.Policies
	policies != []

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Policies", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.Policies' is undefined or empty",
		"keyActualValue": "'Resources.Properties.Policies' is not empty",
	}
}
