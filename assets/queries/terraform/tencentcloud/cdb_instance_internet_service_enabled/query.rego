package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.tencentcloud_mysql_instance[name]
    resource.internet_service == 1

	result := {
		"documentId": input.document[i].id,
		"resourceType": "tencentcloud_mysql_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_mysql_instance[%s].internet_service", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("[%s] has 'internet_service' set to 0 or undefined", [name]),
		"keyActualValue": sprintf("[%s] has 'internet_service' set to 1", [name]),
        "searchLine":common_lib.build_search_line(["resource", "tencentcloud_mysql_instance", name, "internet_service"], []),
	}
}
