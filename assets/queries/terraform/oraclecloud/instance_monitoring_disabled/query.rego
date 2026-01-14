package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.oci_core_instance[name]
	agent_config := resource.agent_config
	agent_config.is_monitoring_disabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "oci_core_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("oci_core_instance[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'is_monitoring_disabled' should be set to false.",
		"keyActualValue": "Attribute 'is_monitoring_disabled' is set to true.",
		"searchLine": common_lib.build_search_line(["resource", "oci_core_instance", name, "agent_config", "is_monitoring_disabled"], []),
	}
}