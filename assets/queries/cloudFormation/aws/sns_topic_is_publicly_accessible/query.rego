package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SNS::TopicPolicy"

	policy := resource.Properties.PolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[j]
	common_lib.is_allow_effect(statement)
	common_lib.any_principal(statement)

	not is_access_limited_to_an_account_id(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement should not allow actions from all principals", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement allows actions from all principals", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "PolicyDocument"], []),
	}
}

is_access_limited_to_an_account_id(statement) {
	common_lib.valid_key(statement, "Condition")
	condition_keys := ["aws:SourceOwner", "aws:SourceAccount", "aws:ResourceAccount", "aws:PrincipalAccount", "aws:VpceAccount"]
	condition_operator := statement.Condition[op][key]
	lower(key) == lower(condition_keys[_])
}