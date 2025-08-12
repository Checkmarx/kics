package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

ilegal_actions := ["s3:GetObject", "ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath", "secretsmanager:GetSecretValue","*","s3:*"] 

CxPolicy[result] {
	types := ["AWS::IAM::Group", "AWS::IAM::Role", "AWS::IAM::User"]

	resource := input.document[i].Resources[name]
	resource.Type == types[_]
	
	policy := resource.Properties.Policies[i2].PolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[st_index]

	common_lib.is_allow_effect(statement)
	ilegal_action := is_ilegal(statement.Action)
	ilegal_action != "none"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Policies.%d.PolicyDocument.Statement.%d.Action", [name,i2,st_index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Policies[%d].PolicyDocument.Statement[%d].Action' shouldn't contain ilegal actions",[name,i2,st_index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Policies[%d].PolicyDocument.Statement[%d].Action' contains [%s]",[name,i2,st_index,ilegal_action]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties","Policies",i2, "PolicyDocument", "Statement", st_index, "Action"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	types := ["AWS::IAM::ManagedPolicy","AWS::IAM::Policy"]
	resource.Type == types[_]

	policy := resource.Properties.PolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[st_index]

	common_lib.is_allow_effect(statement)
	ilegal_action := is_ilegal(statement.Action)
	ilegal_action != "none"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement.%d.Action", [name,st_index]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PolicyDocument.Statement[%d].Action' shouldn't contain ilegal actions",[name,st_index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PolicyDocument.Statement[%d].Action' contains [%s]",[name,st_index,ilegal_action]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "PolicyDocument", "Statement", st_index, "Action"], []),
	}
}

is_ilegal(Action) = Action {
	is_string(Action)
	Action == ilegal_actions[_]
} else = res {
	is_array(Action)
	illegal_actions_list := [a |
    	a := Action[_]
    	ilegal_actions[_] == a
	]
	res := concat(", ", illegal_actions_list)
	res != ""
} else = "none"