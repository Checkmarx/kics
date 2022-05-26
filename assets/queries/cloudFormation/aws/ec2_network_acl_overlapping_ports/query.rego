package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	prop1 := document.Resources[name1]
	prop2 := document.Resources[name2]

	name1 != name2

	prop1.Type == "AWS::EC2::NetworkAclEntry"
	prop2.Type == "AWS::EC2::NetworkAclEntry"

	from1 := prop1.Properties.PortRange.From
	to1 := prop1.Properties.PortRange.To

	from2 := prop2.Properties.PortRange.From
	to2 := prop2.Properties.PortRange.To

	range1 := numbers.range(from1, to1)
	range2 := numbers.range(from2, to2)

	check_overlap(range1, range2)

	result := {
		"documentId": input.document[i].id,
		"resourceType": prop1.Type,
		"resourceName": cf_lib.get_resource_name(prop1, name1),
		"searchKey": sprintf("Resources.%s.Properties.PortRange", [name1]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PortRange should be configured with a different unused port range to avoid overlapping'", [name1]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PortRange has port rage config that is overlapping with others resources and causing ineffective rules'", [name1]),
	}
}

check_overlap(range1, range2) {
	some j, k
	range1[j] = range2[k]
}
