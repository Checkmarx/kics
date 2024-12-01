package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.kubernetes_stateful_set[name]

	volume_claim_template := resource.spec.volume_claim_template
	storage := volume_claim_template.spec.resources.requests.storage

	result := {
		"documentId": document.id,
		"resourceType": "kubernetes_stateful_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template.spec.resources.requests.storage", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template.spec.resources.requests.storage should not be set", [name]),
		"keyActualValue": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template.spec.resources.requests.storage is set to %s", [name, storage]),
	}
}
