package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resources := input.document[i].Resources
	resource := resources[name]

	resource.Type == "AWS::Lambda::Function"

	# check if the role referenced in the lambda function properties is defined in the same template
	fullRole := split(resource.Properties.Role, ".")
	role := fullRole[0]
	resources[role]

	policy := resources[role].Properties.Policies[p]

	check_policy(policy.PolicyDocument)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Policies.PolicyDocument", [role]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Policies[%s].PolicyDocument should not give admin privileges to Resources.%s ", [role, policy.PolicyName, name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Policies[%s].PolicyDocument gives admin privileges to Resources.%s ", [role, policy.PolicyName, name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "Policies", p], ["PolicyDocument"]),
	}
}

check_policy(policy) {
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
    common_lib.containsOrInArrayContains(statement.Resource, "*")
	common_lib.containsOrInArrayContains(statement.Action, "*")
}
