package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::EMR::Cluster"
	properties := resource.Properties

	attrs := {"Ec2SubnetId", "Ec2SubnetIds"}

	count({x | attr := attrs[x]; common_lib.valid_key(properties.Instances, attr)}) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Instances", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Instances.Ec2SubnetId is defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Instances.Ec2SubnetId is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Instances"], []),
	}
}
