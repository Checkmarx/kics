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
		"keyExpectedValue": sprintf("'Resources.%s.Properties.CidrBlock should not be denied to traffic once RuleAction should be configured with allow.' ", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.CidrBlock will be denied to traffic since RuleAction is configured with deny.' ", [name]),
	}
}
