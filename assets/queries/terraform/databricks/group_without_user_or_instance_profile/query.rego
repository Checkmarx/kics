package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	databricks_group := input.document[i].resource.databricks_group[name]

	without_instance_profile(name)
	without_user(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_databricks_group",
		"resourceName": tf_lib.get_resource_name(databricks_group, name),
		"searchKey": sprintf("databricks_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_databricks_group[%s] should be associated with an databricks_group_member that has at least one user set", [name]),
		"keyActualValue": sprintf("aws_databricks_group[%s] is not associated with an databricks_group_member that has at least one user set", [name]),
	}
}

without_instance_profile(name) {
	count({x | resource := input.document[x].resource.databricks_group_instance_profile; has_membership_associated(resource, name); not empty(resource)}) == 0
}

has_membership_associated(resource, name) {
	attributeSplit := split(resource[_].group_id, ".")
	attributeSplit[1] == name
}

empty(resource) {
	count(resource[_].instance_profile_id) == 0
}

without_user(name) {
	count({x | resource := input.document[x].resource.databricks_group_member; has_membership_associated(resource, name); not empty(resource)}) == 0
}

empty_user(resource) {
	count(resource[_].member_id) == 0
}
