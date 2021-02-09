package Cx

CxPolicy[result] {
	entry1 := input.document[i].Resources[name]
	entry1.Type == "AWS::EC2::NetworkAclEntry"

	entry2 := input.document[_].Resources[_]
	entry2.Type == "AWS::EC2::NetworkAclEntry"

	entry1 != entry2

	# Refer the same Network ACL
	getRef(entry1.Properties.NetworkAclId) == getRef(entry2.Properties.NetworkAclId)

	# Both egress or both ingress
	getTraffic(entry1) == getTraffic(entry2)

	# Same rule number
	compareRuleNumber(entry1, entry2)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.RuleNumber", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s' has not the same rule number as other entry for the same NetworkACL", [name]),
		"keyActualValue": sprintf("'Resources.%s' has the same rule number as other entry for the same NetworkACL", [name]),
	}
}

getRef(obj) = obj.Ref {
	object.get(obj, "Ref", "undefined") != "undefined"
} else = obj {
	true
}

getTraffic(entry) = "egress" {
	object.get(entry.Properties, "Egress", "undefined") == true
} else = "ingress" {
	true
}

compareRuleNumber(entry1, entry2){
    ruleNumberEntry1 := to_number(entry1.Properties.RuleNumber)
    ruleNumberEntry2 := to_number(entry2.Properties.RuleNumber)
    ruleNumberEntry1 == ruleNumberEntry2
}
