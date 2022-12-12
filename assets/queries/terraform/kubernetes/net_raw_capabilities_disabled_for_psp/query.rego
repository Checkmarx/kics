package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	spec := resource.spec
	not commonLib.compareArrays(spec.required_drop_capabilities, ["ALL", "NET_RAW"])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.required_drop_capabilities", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "spec.required_drop_capabilities 'is ALL or NET_RAW'",
		"keyActualValue": "spec.required_drop_capabilities 'is not ALL or NET_RAW'",
		"searchLine": commonLib.build_search_line(["resource", "kubernetes_pod_security_policy" ,name, "spec"],["required_drop_capabilities"]),
	}
}
