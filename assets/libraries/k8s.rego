package generic.k8s

import data.generic.common as common_lib
import future.keywords.in

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

checkKindWithKnative(doc, listKinds, knativeKinds) {
	doc.kind == listKinds[i]
} else {
	contains(doc.apiVersion, "knative")
	doc.kind == knativeKinds[i]
}


hasFlag(container, flag) {
	common_lib.inArray(container.command, flag)
} else {
	common_lib.inArray(container.args, flag)
}

startWithFlag(container, flag) {
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

startAndEndWithFlag(container, flag, ext) {
	startWithAndEndWithArray(container.command, flag, ext)
} else {
	startWithAndEndWithArray(container.args, flag, ext)
}

startWithAndEndWithArray(arr, item, ext) {
	startswith(arr[_], item)
	endswith(arr[_], ext)
}

hasFlagEqualOrGreaterThanValue(container, flag, value) {
	command := container.command
	startswith(command[a], flag)
	flag_value := split(command[a], "=")[1]
	to_number(flag_value) >= value
} else {
	args := container.args
	startswith(args[a], flag)
	flag_value := split(args[a], "=")[1]
	to_number(flag_value) >= value
}

hasFlagBetweenValues(container, flag, higher, lower) {
	command := container.command
	startswith(command[a], flag)
	value := split(command[a], "=")[1]
	betweenValues(value, higher, lower)
} else {
	args := container.args
	startswith(args[a], flag)
	value := split(args[a], "=")[1]
	betweenValues(value, higher, lower)
}

betweenValues(value, higher, lower) {
	to_number(value) > higher
	to_number(value) < lower
}

# Valid K8s/Knative Kinds that support podSpec or PodSpecTemplate
# https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/#podspec-v1-core
valid_pod_spec_kind_list = [
	"Pod",
	"Configuration",
	"Service",
	"Revision",
	"ContainerSource",
]

# returns a valid search line path for the given object and array values
# if the array values are partial valid, it will return the valid parts
get_valid_search_line_path(object, array_vals) = obj {
	arr := [x |
		some i, _ in array_vals
		path := array.slice(array_vals, 0, i + 1)
		walk(object, [path, _]) # evaluates to false if path is not in object
		x := path[i]
	]
	obj:= {
        "searchLine": arr,
        "searchKey": get_search_key(arr),
	}
}

get_search_key(array_vals) = searchKeyPath {
    count(array_vals) > 0
    searchKeyPath := sprintf(".%s", [concat(".", array_vals)])
} else = searchKeyPath {
    searchKeyPath := ""
}
