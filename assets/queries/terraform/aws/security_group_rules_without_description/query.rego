package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	#Case of "aws_vpc_security_group_(ingress|egress)_rule" or "aws_security_group_rule" without description
    types := ["aws_vpc_security_group_ingress_rule","aws_vpc_security_group_egress_rule","aws_security_group_rule"]

    resource := input.document[i].resource[types[i2]][name]
    not common_lib.valid_key(resource, "description")

    result := {
        "documentId": input.document[i].id,
        "resourceType": types[i2],
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("%s[%s]", [types[i2], name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("%s[%s].description should be defined and not null", [types[i2], name]),
        "keyActualValue": sprintf("%s[%s].description is undefined or null", [types[i2], name]),
        "searchLine": common_lib.build_search_line(["resource", types[i2], name], []),
    }
}

CxPolicy[result] {
	#Case of "aws_security_group" ingress/egress without description
	security_group := input.document[i].resource.aws_security_group[name]
	types := {"ingress", "egress"}
	resource := security_group[types[y]]

	gress_list := tf_lib.get_ingress_list(resource)
	results := check_description(gress_list.value[i2],gress_list.is_unique_element,name,i2,types[y])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": "MissingAttribute",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
	}
}

CxPolicy[result] {
	#Case of "security-group" Module (ingress|egress)_with_cidr_blocks (ipv4/ipv6) without description
	module := input.document[i].module[name]
	types := ["ingress_with_cidr_blocks","egress_with_cidr_blocks","ingress_with_ipv6_cidr_blocks","egress_with_ipv6_cidr_blocks"]
	key := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group", types[t])
	common_lib.valid_key(module, key)

	target := module[key][i2]

	not common_lib.valid_key(target, "description")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s.%d", [name, key, i2]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("module[%s].%s.%d.description should be defined and not null",[name, key, i2]),
		"keyActualValue": sprintf("module[%s].%s.%d.description is undefined or null",[name, key, i2]),
		"searchLine": common_lib.build_search_line(["module", name, key, i2], []),
	}
}

check_description(resource,is_unique_element,name,resourceIndex,type) = results {
	is_unique_element
	not common_lib.valid_key(resource, "description")

	results := {
		"searchKey" : sprintf("aws_security_group[%s].%s", [name, type]),
		"keyExpectedValue" : sprintf("aws_security_group[%s].%s.description should be defined and not null", [name, type]),
		"keyActualValue" : sprintf("aws_security_group[%s].%s.description is undefined or null", [name, type]),
		"searchLine" : common_lib.build_search_line(["resource", "aws_security_group", name, type], []),
	}
} else = results {
	not is_unique_element
	not common_lib.valid_key(resource, "description")

	results := {
		"searchKey" : sprintf("aws_security_group[%s].%s.%d", [name, type,resourceIndex]),
		"keyExpectedValue": sprintf("aws_security_group[%s].%s[%d].description should be defined and not null", [name, type,resourceIndex]),
		"keyActualValue": sprintf("aws_security_group[%s].%s[%d].description is undefined or null", [name, type,resourceIndex]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, type, resourceIndex], []),
	}
}
