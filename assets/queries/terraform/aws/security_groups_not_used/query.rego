package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_security_group[securityGroupName]

	not is_used(securityGroupName, doc, resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, securityGroupName),
		"searchKey": sprintf("aws_security_group[%s]", [securityGroupName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_security_group[%s]' should be used", [securityGroupName]),
		"keyActualValue": sprintf("'aws_security_group[%s]' is not used", [securityGroupName]),
	}
}

is_used(securityGroupName, doc, _) {
	[_, value] := walk(doc)
	securityGroupUsed := get_security_groups_if_exists(value)[_]
	contains(securityGroupUsed, sprintf("aws_security_group.%s.", [securityGroupName]))
}

is_used(securityGroupName, doc, resource) {
	sec_group_used := resource.name
    [_, value] := walk(doc)
	securityGroupUsed := value.security_groups[_]
	sec_group_used == securityGroupUsed
}


get_security_groups_if_exists(resource) = security_group {
	security_group := resource.security_groups
} else = security_group {
	# check in modules for module terraform-aws-modules/security-group/aws (array)
	is_array(resource.security_group_id)
	security_group := resource.security_group_id
} else = security_group {
	# terraform-aws-modules/security-group/aws (not an array)
	not is_array(resource.security_group_id)
	security_group := [resource.security_group_id]
} else = security_group {
	# check security groups assigned to aws_elasticache_instance resources
	security_group := resource.security_group_ids
} else = security_group {
	# check security groups assigned to aws_instance resources
	security_group := resource.vpc_security_group_ids
} else = security_group {
	# check security groups assigned to aws_eks_cluster resources
	security_group := resource.vpc_config.security_group_ids
}