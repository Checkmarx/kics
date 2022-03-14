package generic.k8s

import data.generic.common as common_lib

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

checkKind(currentKind, listKinds) {
	currentKind == listKinds[i]
}

hasFlag(container, flag) {
	common_lib.inArray(container.command, flag)
} else {
	common_lib.inArray(container.args, flag)
}
