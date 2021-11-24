package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	org_policy := input.document[i].resource.aws_organizations_policy[name]

	serviceControlPolicy(object.get(org_policy, "type", "undefined"))

	content := common_lib.json_unmarshal(org_policy.content)

	st := common_lib.get_statement(content)
	statement := st[_]

	not policy_check(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_organizations_policy[%s].content", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Statements allow all policy actions in all resources",
		"keyActualValue": "Some or all statements don't allow all policy actions in all resources",
		"searchLine": common_lib.build_search_line(["resource", "aws_organizations_policy", name, "content"], []),
	}
}

serviceControlPolicy("SERVICE_CONTROL_POLICY") = true

serviceControlPolicy("undefined") = true

policy_check(statement) {
	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Action, "*")
	common_lib.equalsOrInArray(statement.Resource, "*")
}
