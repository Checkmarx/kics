package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	org_policy := input.document[i].resource.aws_organizations_policy[name]

	serviceControlPolicy(object.get(org_policy, "type", "undefined"))

	content := commonLib.json_unmarshal(org_policy.content)

	checkStatements(content.Statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_organizations_policy[%s].content", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Statements allow all policy actions in all resources",
		"keyActualValue": "Some or all statements don't allow all policy actions in all resources",
	}
}

serviceControlPolicy("SERVICE_CONTROL_POLICY") = true

serviceControlPolicy("undefined") = true

checkStatements(statements) {
	is_array(statements)
	some j
	statement := statements[j]
	not policy_check(statement)
}

checkStatements(statement) {
	is_object(statement)
	not policy_check(statement)
}

policy_check(statement) {
	statement.Effect == "Allow"
	commonLib.equalsOrInArray(statement.Action, "*")
	commonLib.equalsOrInArray(statement.Resource, "*")
}
