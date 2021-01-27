package Cx

CxPolicy[result] {
	org_policy := input.document[i].resource.aws_organizations_policy[name]

	org_policy.type == "SERVICE_CONTROL_POLICY"

	content := json.unmarshal(org_policy.content)

	checkStatements(content.Statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_organizations_policy[%s].content", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Statements allow all policy actions in all resources",
		"keyActualValue": "Some or all statements don't allow all policy actions in all resources",
	}
}

CxPolicy[result] {
	org_policy := input.document[i].resource.aws_organizations_policy[name]

	not org_policy.type # default is SERVICE_CONTROL_POLICY

	content := json.unmarshal(org_policy.content)

	checkStatements(content.Statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_organizations_policy[%s].content", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Statements allow all policy actions in all resources",
		"keyActualValue": "Some or all statements don't allow all policy actions in all resources",
	}
}

checkStatements(statements) {
	is_array(statements)
	some j
	statement := statements[j]
	not policy_check(statement, "*", "Allow", "*")
}

checkStatements(statement) {
	not is_array(statement)
	not policy_check(statement, "*", "Allow", "*")
}

policy_check(statement, action, effect, resource) {
	statement.Effect == effect
	is_action_array := is_array(statement.Action)
	statement.Action[_] == action
	is_resource_array := is_array(statement.Resource)
	statement.Resource[_] == resource
}

policy_check(statement, action, effect, resource) {
	statement.Effect == effect
	is_action_array := is_array(statement.Action)
	statement.Action[_] == action
	is_resource_string := is_string(statement.Resource)
	statement.Resource == resource
}

policy_check(statement, action, effect, resource) {
	statement.Effect == effect
	is_action_string := is_string(statement.Action)
	statement.Action == action
	is_resource_array := is_array(statement.Resource)
	statement.Resource[_] == resource
}

policy_check(statement, action, effect, resource) {
	statement.Effect == effect
	is_action_string := is_string(statement.Action)
	statement.Action == action
	is_resource_string := is_string(statement.Resource)
	statement.Resource == resource
}
