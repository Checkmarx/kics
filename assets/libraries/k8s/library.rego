package generic.k8s

getSpecInfo(document) = specInfo { # this one can be also used for the result
	templates := {"job_template", "jobTemplate"}
	spec := document.spec[templates[t]].spec.template.spec
	specInfo := {"spec": spec, "path": sprintf("spec.%s.spec.template.spec", [templates[t]])}
} else = specInfo {
	spec := document.spec.template.spec
	specInfo := {"spec": spec, "path": "spec.template.spec"}
} else = specInfo {
	spec := document.spec
	specInfo := {"spec": spec, "path": "spec"}
}

CheckIFPdbExists(statefulset) = result {
	pdb := input.document[j]
	pdb.kind == "PodDisruptionBudget"
	result := contains(pdb, statefulset.spec.selector.matchLabels)
} else = false {
	true
}

contains(array, label) {
	array.spec.selector.matchLabels[_] == label[_]
}
