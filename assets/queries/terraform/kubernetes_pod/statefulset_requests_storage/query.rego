package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_stateful_set[name]

	volume_claim_template := resource.spec.volume_claim_template
	storage := volume_claim_template.spec.resources.requests.storage

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template.spec.resources.requests.storage", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template.spec.resources.requests.storage should not be set", [name]),
		"keyActualValue": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template.spec.resources.requests.storage is set to %s", [name, storage]),
	}
}
