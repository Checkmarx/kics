package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Policy"
	
	policy := resource.Properties.PolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Resource, "*")
	common_lib.equalsOrInArray(statement.Action, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocumentt", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.PolicyDocument.Statement' doesn't contain '*'",
		"keyActualValue": "'Resources.Properties.PolicyDocument.Statement' contains '*'",
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "PolicyDocument"], []),
	}
}
