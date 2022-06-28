package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_horizontal_pod_autoscaler[name]

	metric := resource.spec.metric

	not checkIsValidObject(metric)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_horizontal_pod_autoscaler",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_horizontal_pod_autoscaler[%s].spec.metric", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_horizontal_pod_autoscaler[%s].spec.metric is a valid object", [name]),
		"keyActualValue": sprintf("kubernetes_horizontal_pod_autoscaler[%s].spec.metric is a invalid object", [name]),
	}
}

checkIsValidObject(resource) {
	resource.type == "Object"
	resource.object != null
	resource.object.metric != null
	resource.object.target != null
	resource.object.described_object.name != null
	resource.object.described_object.api_version != null
	resource.object.described_object.kind != null
}
