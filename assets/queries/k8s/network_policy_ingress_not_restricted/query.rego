package Cx

import data.generic.common as common_lib

# An ingress rule without a 'from' block allows traffic from ALL sources (any IP).
CxPolicy[result] {
	document := input.document[i]
	document.kind == "NetworkPolicy"
	metadata := document.metadata
	spec := document.spec

	ingress_in_scope(spec)

	ingress_rule := spec.ingress[j]
	not common_lib.valid_key(ingress_rule, "from")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.ingress", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("NetworkPolicy '%s' ingress rule [%d] should define a 'from' block to restrict source IPs", [metadata.name, j]),
		"keyActualValue": sprintf("NetworkPolicy '%s' ingress rule [%d] has no 'from' block, allowing traffic from all sources", [metadata.name, j]),
	}
}

# policyTypes explicitly includes Ingress
ingress_in_scope(spec) {
	lower(spec.policyTypes[_]) == "ingress"
}

# policyTypes is absent — K8s defaults to controlling Ingress when ingress rules are present
ingress_in_scope(spec) {
	not common_lib.valid_key(spec, "policyTypes")
	common_lib.valid_key(spec, "ingress")
}
