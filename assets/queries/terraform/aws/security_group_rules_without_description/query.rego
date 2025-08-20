package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    #Case of aws_vpc_security_group_(ingress|egress)_rule or aws_security_group_rule without description
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
	#Case of Single Ingress/Egress without description
	resource := input.document[i].resource.aws_security_group[name]
	types := {"ingress", "egress"}
	resourceType := resource[types[y]]
    not is_array(resourceType)
	not common_lib.valid_key(resourceType, "description")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].%s", [name, types[y]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_security_group[%s].%s description should be defined and not null", [name, types[y]]),
		"keyActualValue": sprintf("aws_security_group[%s].%s description is undefined or null", [name, types[y]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, types[y]], []),
	}
}

CxPolicy[result] {
	#Case of Ingress/Egress Array element without description
	resource := input.document[i].resource.aws_security_group[name]
	types := {"ingress", "egress"}
	resourceType := resource[types[y]]
    is_array(resourceType)
    currentResource := resourceType[resourceIndex]
	not common_lib.valid_key(currentResource, "description")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_security_group[%s].%s", [name, types[y]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_security_group[%s].%s description should be defined and not null", [name, types[y]]),
		"keyActualValue": sprintf("aws_security_group[%s].%s description is undefined or null", [name, types[y]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, types[y], resourceIndex], []),
	}
}


