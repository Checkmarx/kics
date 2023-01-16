package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	databricks_group := input.document[i].resource.databricks_group[name]

	without_users(name)

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

without_users(name) {
	count({x | resource := input.document[x].resource.databricks_group_member; has_membership_associated(resource, name); not empty(resource)}) == 0
}

has_membership_associated(resource, name) {
	attributeSplit := split(resource[_].group_id, ".")
	attributeSplit[1] == name
}

empty(resource) {
	count(resource[_].member_id) == 0
}
