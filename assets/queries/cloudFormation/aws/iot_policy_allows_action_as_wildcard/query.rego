package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resources := input.document[i].Resources[name]
	resources.Type == "AWS::IoT::Policy"

	policy := resources.Properties.PolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Action is not '*'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Action is '*'", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "PolicyDocument"], []),
	}
}
