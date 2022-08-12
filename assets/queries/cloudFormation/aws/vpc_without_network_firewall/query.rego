package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::EC2::VPC"

	not with_network_firewall(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s' should be associated with a AWS Network Firewall", [name]),
		"keyActualValue": sprintf("'Resources.%s' is not associated with a AWS Network Firewall", [name]),
		"searchLine": common_lib.build_search_line(path, [name]),
	}
}

with_network_firewall(vpcName) {
	[_, Resources] := walk(input.document[_])
	resource := Resources[_]
	resource.Type == "AWS::NetworkFirewall::Firewall"

	vpcName == get_name(resource.Properties.VpcId)
}

get_name(vpc) = name {
	common_lib.valid_key(vpc, "Ref")
	name := vpc.Ref
} else = name {
	name := vpc
}
