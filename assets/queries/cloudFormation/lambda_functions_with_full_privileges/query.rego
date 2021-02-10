package Cx

CxPolicy[result] {
	resources := input.document[i].Resources
	resource := resources[name]

	resource.Type == "AWS::Lambda::Function"

	# check if the role referenced in the lambda function properties is defined in the same template
	fullRole := split(resource.Properties.Role, ".")
	role := fullRole[0]
	resources[role]

	checkPolicies(resources[role].Properties.Policies)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Policies.PolicyDocument", [role]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Policies.PolicyDocument does not give admin privileges to Resources.%s ", [role, name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Policies.PolicyDocument gives admin privileges to Resources.%s ", [role, name]),
	}
}

checkPolicies(policies) {
	some j, k
	statement := policies[j].PolicyDocument.Statement[k]
	statement.Effect == "Allow"
	checkResource(statement)
	checkAction(statement)
}

checkResource(statement) {
	statement.Resource == "*"
}

checkResource(statement) {
	endswith(statement.Resource, "*")
}

checkAction(statement) {
	statement.Action[_] == "*"
}

checkAction(statement) {
	endswith(statement.Action[_], "*")
}
