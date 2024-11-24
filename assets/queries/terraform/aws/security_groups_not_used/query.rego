package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_security_group[securityGroupName]

	not is_used(securityGroupName, doc, resource)

	result := {
		"documentId": doc.id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, securityGroupName),
		"searchKey": sprintf("aws_security_group[%s]", [securityGroupName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_security_group[%s]' should be used", [securityGroupName]),
		"keyActualValue": sprintf("'aws_security_group[%s]' is not used", [securityGroupName]),
	}
}

is_used(securityGroupName, doc, resource) {
	[path, value] := walk(doc)
	some securityGroupUsed in value.security_groups
	contains(securityGroupUsed, sprintf("aws_security_group.%s", [securityGroupName]))
}

# check in modules for module terraform-aws-modules/security-group/aws
is_used(securityGroupName, doc, resource) {
	[path, value] := walk(doc)
	securityGroupUsed := value.security_group_id
	contains(securityGroupUsed, sprintf("aws_security_group.%s", [securityGroupName]))
}

# check security groups assigned to aws_elasticache_instance resources
is_used(securityGroupName, doc, resource) {
	[path, value] := walk(doc)
	some securityGroupUsed in value.security_group_ids
	contains(securityGroupUsed, sprintf("aws_security_group.%s", [securityGroupName]))
}

# check security groups assigned to aws_instance resources
is_used(securityGroupName, doc, resource) {
	[path, value] := walk(doc)
	some securityGroupUsed in value.vpc_security_group_ids
	contains(securityGroupUsed, sprintf("aws_security_group.%s", [securityGroupName]))
}

# check security groups assigned to aws_eks_cluster resources
is_used(securityGroupName, doc, resource) {
	[path, value] := walk(doc)
	some securityGroupUsed in value.vpc_config.security_group_ids
	contains(securityGroupUsed, sprintf("aws_security_group.%s", [securityGroupName]))
}

is_used(securityGroupName, doc, resource) {
	sec_group_used := resource.name
	[path, value] := walk(doc)
	some securityGroupUsed in value.security_groups
	sec_group_used == securityGroupUsed
}
