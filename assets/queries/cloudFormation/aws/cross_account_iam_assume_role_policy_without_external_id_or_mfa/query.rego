package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Role"

	policy := resource.Properties.AssumeRolePolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)

	common_lib.is_cross_account(statement)
	common_lib.is_assume_role(statement)

	not common_lib.has_external_id(statement)
	not common_lib.has_mfa(statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument requires external ID or MFA", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument does not require external ID or MFA", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "AssumeRolePolicyDocument"], []),
	}
}
