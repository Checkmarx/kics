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
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Policies' is undefined or empty", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Policies' is not empty", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::User"
	policies := resource.Properties.ManagedPoliciesArns
	policies != []

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.ManagedPoliciesArns", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ManagedPoliciesArns' is undefined or empty", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ManagedPoliciesArns' is not empty", [name]),
	}
}
