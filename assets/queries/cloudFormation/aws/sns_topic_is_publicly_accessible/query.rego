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

	not common_lib.is_access_limited_to_an_account_id(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement shouldn't contain '*' for an AWS Principal", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement contains '*' in an AWS Principal", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "PolicyDocument"], []),
	}
}