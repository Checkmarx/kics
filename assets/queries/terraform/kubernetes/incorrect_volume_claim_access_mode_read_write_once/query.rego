package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_stateful_set[name]

	volume_claim_template := resource.spec.volume_claim_template
	vClaimsWitReadWriteOnce := [vClaims | contains(volume_claim_template[vm].spec.access_modes[am], "ReadWriteOnce") == true; vClaims := volume_claim_template[vm].metadata.name]
	count(vClaimsWitReadWriteOnce) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_stateful_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template has one template with a 'ReadWriteOnce'", [name]),
		"keyActualValue": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template does not have a template with a 'ReadWriteOnce'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_stateful_set[name]

	volume_claim_template := resource.spec.volume_claim_template
	vClaimsWitReadWriteOnce := [vClaims | contains(volume_claim_template[vm].spec.access_modes[am], "ReadWriteOnce") == true; vClaims := volume_claim_template[vm].metadata.name]
	count(vClaimsWitReadWriteOnce) > 1

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_stateful_set",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template has only one template with a 'ReadWriteOnce'", [name]),
		"keyActualValue": sprintf("kubernetes_stateful_set[%s].spec.volume_claim_template has multiple templates with 'ReadWriteOnce'", [name]),
	}
}
