package Cx

CxPolicy[result] {
	resources := input.document[i].Resources
	resource := resources[name]

	resource.Type == "AWS::Lambda::Function"

	# check if the role referenced in the lambda function properties is defined in the same template
	fullRole := split(resource.Properties.Role, ".")
	role := fullRole[0]
	resources[role]

	policyName := checkPolicies(resources[role].Properties.Policies)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Policies.PolicyDocument", [role]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Policies[%s].PolicyDocument does not give admin privileges to Resources.%s ", [role, policyName, name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Policies[%s].PolicyDocument gives admin privileges to Resources.%s ", [role, policyName, name]),
	}
}

CxPolicy[result] {
	resources := input.document[i].Resources
	resource := resources[name]

	resource.Type == "AWS::Lambda::Function"

	# check if the role referenced in the lambda function properties is defined in the same template
	fullRole := split(resource.Properties.Role, ".")
	role := fullRole[0]
	resources[role]

	policyName := checkPoliciesActionArray(resources[role].Properties.Policies)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Policies.PolicyDocument", [role]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Policies[%s].PolicyDocument does not give admin privileges to Resources.%s ", [role, policyName, name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Policies[%s].PolicyDocument gives admin privileges to Resources.%s ", [role, policyName, name]),
	}
}

checkPolicies(policies) = policyName {
	some j, k
	statement := policies[j].PolicyDocument.Statement[k]
	statement.Effect == "Allow"
	checkResource(statement)
	checkAction(statement)
    policyName := policies[j].PolicyName
}

checkPoliciesActionArray(policies) = policyName {
	some j, k
	statement := policies[j].PolicyDocument.Statement[k]
	statement.Effect == "Allow"
	checkResource(statement)
	checkActionArray(statement)
    policyName := policies[j].PolicyName
}

checkResource(statement) {
	contains(statement.Resource, "*")
}

checkActionArray(statement) {
	contains(statement.Action[_], "*")
}

checkAction(statement) {
	contains(statement.Action, "*")
}
