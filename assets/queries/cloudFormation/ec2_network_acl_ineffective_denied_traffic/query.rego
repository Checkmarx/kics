package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::NetworkAclEntry"
	action := resource.Properties.RuleAction
	cidr := resource.Properties.CidrBlock
	not contains(cidr, "0.0.0.0/0")
	contains(action, "deny")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.CidrBlock", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Traffic denial is effective (Action is 'Deny' when CidrBlock is '0.0.0.0/0')", [name]),
		"keyActualValue": sprintf("Traffic denial is ineffective (Action is 'Deny' when CidrBlock is different from '0.0.0.0/0'", [name]),
	}
}
