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

startWithFlag(container, flag){
	startsWithArray(container.command, flag)
} else {
	startsWithArray(container.args, flag)
}

startsWithArray(arr, item) {
    startswith(arr[_], item)
}

hasFlagWithValue(container, flag, value) {
	command := container.command
	startswith(command[a], flag)
	values := split(command[a], "=")[1]
	hasValue(values, value)
} else {
	args := container.args
	startswith(args[a], flag)
	values := split(args[a], "=")[1]
	hasValue(values, value)
}

hasValue(values, value) {
	splittedValues := split(values, ",")
	splittedValues[_] == value
}

hasFlagEqualOrGreaterThanValue(container, flag, value) {
	command := container.command
	startswith(command[a], flag)
	flag_value := split(command[a], "=")[1]
	to_number(flag_value)>= value
} else {
	args := container.args
	startswith(args[a], flag)
	flag_value := split(args[a], "=")[1]
	to_number(flag_value)>= value
}
