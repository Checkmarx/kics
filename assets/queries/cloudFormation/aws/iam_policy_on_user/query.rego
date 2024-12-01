package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	some policyName
	document.Resources[policyName].Type == "AWS::IAM::Policy"
	policy := document.Resources[policyName]

	count(policy.Properties.Users) > 0

	result := {
		"documentId": document.id,
		"resourceType": document.Resources[policyName].Type,
		"resourceName": cf_lib.get_resource_name(document.Resources[policyName], policyName),
		"searchKey": sprintf("Resources.%s.Properties.Users", [policyName]),
		"issueType": "IncorrectValue", # "MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": sprintf("Resources.%s is assigned to a set of users", [policyName]),
		"keyActualValue": sprintf("Resources.%s should be assigned to a set of groups", [policyName]),
	}
}
