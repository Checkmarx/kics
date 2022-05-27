package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	stateful := input.document[i].resource.kubernetes_stateful_set[name]

	count({x | 	resource := input.document[_].resource.kubernetes_service[x];
				resource.spec.cluster_ip == "None"; 
				stateful.metadata.namespace == resource.metadata.namespace;
				stateful.spec.service_name == resource.metadata.name;
				match_labels(stateful.spec.template.metadata.labels, resource.spec.selector) == true}) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_stateful_set",
		"resourceName": tf_lib.get_resource_name(stateful, name),
		"searchKey": sprintf("kubernetes_stateful_set[%s].spec.service_name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_stateful_set[%s].spec.service_name should refer to a Headless Service", [name]),
		"keyActualValue": sprintf("kubernetes_stateful_set[%s].spec.service_name does not refer to a Headless Service", [name]),
	}
}

match_labels(serviceLabels, statefulsetLabels) {
    count({x | label := serviceLabels[x]; label == statefulsetLabels[x]}) == count(serviceLabels)
}
