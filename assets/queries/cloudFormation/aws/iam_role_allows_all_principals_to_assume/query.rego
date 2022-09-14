package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]

	resource.Type == "AWS::IAM::Role"

	policy := resource.Properties.AssumeRolePolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	aws := statement.Principal.AWS

	common_lib.allowsAllPrincipalsToAssume(aws, statement)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.AssumeRolePolicyDocument", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement.Principal.AWS should not contain ':root'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement.Principal.AWS contains ':root'", [name]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "AssumeRolePolicyDocument"]),
	}
}
