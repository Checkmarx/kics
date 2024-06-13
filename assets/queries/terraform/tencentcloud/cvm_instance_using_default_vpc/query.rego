package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.tencentcloud_instance[name]
    vpc_id := resource.vpc_id

    contains(lower(vpc_id), "default")

    result := {
        "documentId": doc.id,
        "resourceType": "tencentcloud_instance",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("tencentcloud_instance[%s].vpc_id", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("tencentcloud_instance[%s].vpc_id should not contain 'default'", [name]),
        "keyActualValue": sprintf("tencentcloud_instance[%s].vpc_id contains 'default'", [name]),
        "searchLine": common_lib.build_search_line(["resource", "tencentcloud_instance", name, "vpc_id"], []),
    }
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.tencentcloud_instance[name]
	subnet_id := resource.subnet_id

    contains(lower(subnet_id), "default")

	result := {
		"documentId": doc.id,
        "resourceType": "tencentcloud_instance",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("tencentcloud_instance[%s].subnet_id", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("tencentcloud_instance[%s].subnet_id should not be associated with a default Subnet", [name]),
        "keyActualValue": sprintf("tencentcloud_instance[%s].subnet_id is associated with a default Subnet", [name]),
        "searchLine": common_lib.build_search_line(["resource", "tencentcloud_instance", name, "subnet_id"], []),
	}
}
