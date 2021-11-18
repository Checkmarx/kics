package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Role"

	policy := common_lib.json_unmarshal(resource.Properties.AssumeRolePolicyDocument)

	statement := common_lib.get_statement(policy)

	statement.Effect == "Allow"

	common_lib.is_cross_account(statement)
	common_lib.is_assume_role(statement)

	not common_lib.has_externalID(statement)
	not common_lib.has_mfa(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument requires external ID or MFA", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument does not require external ID or MFA", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "AssumeRolePolicyDocument"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Role"

	statement := common_lib.get_statement(resource.Properties.AssumeRolePolicyDocument)

	statement.Effect == "Allow"

	common_lib.is_cross_account(statement)
	common_lib.is_assume_role(statement)

	not common_lib.has_externalID(statement)
	not common_lib.has_mfa(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument requires external ID or MFA", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument does not require external ID or MFA", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "AssumeRolePolicyDocument"], []),
	}
}
