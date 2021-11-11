package Cx

CxPolicy[result] {
	doc := input.document[i]
	doc.resource.aws_security_group[securityGroupName]

	not is_used(securityGroupName, doc)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s]", [securityGroupName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_security_group[%s]' is used", [securityGroupName]),
		"keyActualValue": sprintf("'aws_security_group[%s]' is not used", [securityGroupName]),
	}
}

is_used(securityGroupName, doc) {
	[path, value] := walk(doc)
	securityGroupUsed := value.security_groups[_]
	contains(securityGroupUsed, sprintf("aws_security_group.%s", [securityGroupName]))
}

# check in modules for module terraform-aws-modules/security-group/aws
is_used(securityGroupName, doc) {
	[path, value] := walk(doc)
	securityGroupUsed := value.security_group_id
	contains(securityGroupUsed, sprintf("aws_security_group.%s", [securityGroupName]))
}

# check security groups assigned to aws_instance resources
is_used(securityGroupName, doc) {
	[path, value] := walk(doc)
	securityGroupUsed := value.vpc_security_group_ids[_]
	contains(securityGroupUsed, sprintf("aws_security_group.%s", [securityGroupName]))
}
