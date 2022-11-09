package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	deployment := input.document[i]
	object.get(deployment, "kind", "undefined") == "Deployment"

	metadata := deployment.metadata

	to_number(deployment.spec.replicas) > 2

	not common_lib.valid_key(deployment.spec.template.spec, "affinity")

	result := {
		"documentId": input.document[i].id,
		"resourceType": deployment.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'spec.template.spec.affinity' should be set",
		"keyActualValue": "'spec.template.spec.affinity' is undefined",
	}
}

CxPolicy[result] {
	deployment := input.document[i]
	object.get(deployment, "kind", "undefined") == "Deployment"

	to_number(deployment.spec.replicas) > 2

	affinity := deployment.spec.template.spec.affinity
	not common_lib.valid_key(affinity, "podAntiAffinity")

	metadata := deployment.metadata
	result := {
		"documentId": input.document[i].id,
		"resourceType": deployment.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.affinity", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'spec.template.spec.affinity.podAntiAffinity' should be set",
		"keyActualValue": "'spec.template.spec.affinity.podAntiAffinity' is undefined",
	}
}

CxPolicy[result] {
	deployment := input.document[i]
	object.get(deployment, "kind", "undefined") == "Deployment"

	to_number(deployment.spec.replicas) > 2

	affinity := deployment.spec.template.spec.affinity
	common_lib.valid_key(affinity, "podAntiAffinity")

	podAntiAffinity := affinity.podAntiAffinity

	not common_lib.valid_key(podAntiAffinity, "preferredDuringSchedulingIgnoredDuringExecution")
	not common_lib.valid_key(podAntiAffinity, "requiredDuringSchedulingIgnoredDuringExecution")

	metadata := deployment.metadata
	result := {
		"documentId": input.document[i].id,
		"resourceType": deployment.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.affinity.podAntiAffinity", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution' and/or 'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution' should be set",
		"keyActualValue": "'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution' and 'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution' are undefined",
	}
}

CxPolicy[result] {
	deployment := input.document[i]
	object.get(deployment, "kind", "undefined") == "Deployment"

	to_number(deployment.spec.replicas) > 2

	affinity := deployment.spec.template.spec.affinity
	common_lib.valid_key(affinity, "podAntiAffinity")

	podAntiAffinity := affinity.podAntiAffinity

	common_lib.valid_key(podAntiAffinity, "preferredDuringSchedulingIgnoredDuringExecution")

	pref := podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[j]

	object.get(pref.podAffinityTerm, "topologyKey", "undefined") != "kubernetes.io/hostname"

	metadata := deployment.metadata
	result := {
		"documentId": input.document[i].id,
		"resourceType": deployment.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution.podAffinityTerm", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[%s].podAffinityTerm.topologyKey' should be set to 'kubernetes.io/hostname'", [j]),
		"keyActualValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[%s].podAffinityTerm.topologyKey' is invalid or undefined", [j]),
	}
}

CxPolicy[result] {
	deployment := input.document[i]
	object.get(deployment, "kind", "undefined") == "Deployment"

	to_number(deployment.spec.replicas) > 2

	affinity := deployment.spec.template.spec.affinity
	common_lib.valid_key(affinity, "podAntiAffinity")

	podAntiAffinity := affinity.podAntiAffinity

	common_lib.valid_key(podAntiAffinity, "preferredDuringSchedulingIgnoredDuringExecution")

	pref := podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[j]

	object.get(pref.podAffinityTerm, "topologyKey", "undefined") == "kubernetes.io/hostname"

	templateLabels := deployment.spec.template.metadata.labels
	selectorLabels := pref.podAffinityTerm.labelSelector.matchLabels

	match_labels(templateLabels, selectorLabels) == false

	metadata := deployment.metadata
	result := {
		"documentId": input.document[i].id,
		"resourceType": deployment.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution.podAffinityTerm.labelSelector.matchLabels", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[%d].podAffinityTerm.labelSelector.matchLabels' match any label on template metadata", [j]),
		"keyActualValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[%d].podAffinityTerm.labelSelector.matchLabels' don't match any label on template metadata", [j]),
	}
}

CxPolicy[result] {
	deployment := input.document[i]
	object.get(deployment, "kind", "undefined") == "Deployment"

	to_number(deployment.spec.replicas) > 2

	affinity := deployment.spec.template.spec.affinity
	common_lib.valid_key(affinity, "podAntiAffinity")

	podAntiAffinity := affinity.podAntiAffinity

	common_lib.valid_key(podAntiAffinity, "requiredDuringSchedulingIgnoredDuringExecution")

	pref := podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[j]

	object.get(pref, "topologyKey", "undefined") != "kubernetes.io/hostname"

	metadata := deployment.metadata
	result := {
		"documentId": input.document[i].id,
		"resourceType": deployment.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[%d].topologyKey' should be set to 'kubernetes.io/hostname'", [j]),
		"keyActualValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[%d].topologyKey' is invalid or undefined", [j]),
	}
}

CxPolicy[result] {
	deployment := input.document[i]
	object.get(deployment, "kind", "undefined") == "Deployment"

	to_number(deployment.spec.replicas) > 2

	affinity := deployment.spec.template.spec.affinity
	common_lib.valid_key(affinity, "podAntiAffinity")

	podAntiAffinity := affinity.podAntiAffinity

	common_lib.valid_key(podAntiAffinity, "requiredDuringSchedulingIgnoredDuringExecution")

	pref := podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[j]

	object.get(pref, "topologyKey", "undefined") == "kubernetes.io/hostname"

	templateLabels := deployment.spec.template.metadata.labels
	selectorLabels := pref.labelSelector.matchLabels

	match_labels(templateLabels, selectorLabels) == false

	metadata := deployment.metadata
	result := {
		"documentId": input.document[i].id,
		"resourceType": deployment.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution.labelSelector.matchLabels", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[%d].labelSelector.matchLabels' match any label on template metadata", [j]),
		"keyActualValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[%d].labelSelector.matchLabels' don't match any label on template metadata", [j]),
	}
}

match_labels(templateLabels, selectorLabels) {
	some Key
	templateLabels[Key] == selectorLabels[Key]
} else = false {
	true
}
