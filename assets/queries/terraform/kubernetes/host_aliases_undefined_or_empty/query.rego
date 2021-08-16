package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
    not common_lib.valid_key(spec, "host_aliases")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.host_aliases is defined and not null", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.host_aliases is undefined or null", [name]),
	}
}
