package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	resource.Properties.Role
	role := resource.Properties.Role
	resource.Properties.LoadBalancers
	not role.Ref

	check_role(role)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Role should not be an admin role", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Role is an admin role", [name]),
	}
}

check_role(role) {
	is_string(role)
	contains(lower(role), "admin")
}
