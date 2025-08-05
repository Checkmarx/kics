package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

ilegal_actions := ["s3:GetObject", "ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath", "secretsmanager:GetSecretValue","*","s3:*"] 

CxPolicy[result] {
	types := ["AWS::IAM::ManagedPolicy", "AWS::IAM::Group", "AWS::IAM::Role", "AWS::IAM::User"]

	resource := input.document[i].Resources[name]
	resource.Type == types[_]
	
	policy := resource.Properties.Policies[i2].PolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[st_index]

	common_lib.is_allow_effect(statement)
	statement.Action[_] == ilegal_actions[i3]

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Policies.%d.PolicyDocument.Statement.%d", [name,i2,st_index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.Properties.Policies[%d].PolicyDocument.Statement[%d].Action' shouldn't contain %s",[i2,st_index,ilegal_actions[i3]]),
		"keyActualValue": sprintf("'Resources.Properties.Policies[%d].PolicyDocument.Statement[%d].Action' contains %s",[i2,st_index,ilegal_actions[i3]]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties","Policies",i2, "PolicyDocument", "Statement", st_index], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Policy"

	policy := resource.Properties.PolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[st_index]

	common_lib.is_allow_effect(statement)
	statement.Action[_] == ilegal_actions[i3]

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement.%d", [name,st_index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.Properties.PolicyDocument.Statement[%d].Action' shouldn't contain %s",[st_index,ilegal_actions[i3]]),
		"keyActualValue": sprintf("'Resources.Properties.PolicyDocument.Statement[%d].Action' contains %s",[st_index,ilegal_actions[i3]]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "PolicyDocument", "Statement", st_index], []),
	}
}