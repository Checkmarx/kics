package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_mysql_instance[name]
    resource.intranet_port == 3306

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_mysql_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_mysql_instance[%s].intranet_port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("[%s] has 'intranet_port' set to non 3306", [name]),
		"keyActualValue": sprintf("[%s] has 'intranet_port' set to 3306", [name]),
        "searchLine":common_lib.build_search_line(["resource", "tencentcloud_mysql_instance", name, "intranet_port"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_mysql_instance[name]
    not common_lib.valid_key(resource, "intranet_port")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_mysql_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_mysql_instance[%s]",[name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("[%s] 'intranet_port' should be set and the value should not be 3306",[name]),
		"keyActualValue": sprintf("[%s] does not set 'intranet_port'",[name]),
        "searchLine":common_lib.build_search_line(["resource", "tencentcloud_mysql_instance", name], []),
	}
}
