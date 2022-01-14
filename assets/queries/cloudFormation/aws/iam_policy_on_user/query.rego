package Cx

CxPolicy[result] {
	document := input.document[i]
	some policyName
	document.Resources[policyName].Type == "AWS::IAM::Policy"
	policy := document.Resources[policyName]

	count(policy.Properties.Users) > 0

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.Users", [policyName]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": sprintf("Resources.%s is assigned to a set of users", [policyName]),
		"keyActualValue": sprintf("Resources.%s should be assigned to a set of groups", [policyName]),
	}
}
