package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	common_lib.inArray(container.command, "kube-apiserver")
	k8sLib.startWithFlag(container, "--request-timeout")
	hasTimeGreaterThanValue(container, "--request-timeout", 300)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--request-timeout flag should not be set to more than 300 seconds",
		"keyActualValue": "--request-timeout flag is set to more than 300 seconds",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	common_lib.inArray(container.command, "kube-apiserver")
	k8sLib.startWithFlag(container, "--request-timeout")
	not hasValidTimeValue(container, "--request-timeout")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--request-timeout flag should not be set to more than 300 seconds",
		"keyActualValue": "--request-timeout flag has an invalid value",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}

hasTimeGreaterThanValue(container, flag, value) {
	command := container.command
	startswith(command[a], flag)
	flag_value := split(command[a], "=")[1]
	getSeconds(flag_value)> value
} else {
	args := container.args
	startswith(args[a], flag)
	flag_value := split(args[a], "=")[1]
	getSeconds(flag_value)> value
}

getSeconds(time)=seconds{
	regex.match("^(\\d{1,3}[h])$", time)
    seconds := to_number(trim_suffix(time, "h") )*3600    
}else = seconds {
	regex.match("^(\\d{1,3}[h])(\\d{1,3}[m])$", time)
    new_str := replace(time, "h", ",")
    new_str2 := replace(new_str, "m", ",")
    split_aux := split(new_str2, ",")
    seconds := to_number(split_aux[0])*3600 + to_number(split_aux[1])*60
}else = seconds {
	regex.match("^(\\d{1,3}[h])(\\d{1,3}[m])(\\d{1,3}[s])$", time)
    new_str := replace(time, "h", ",")
    new_str2 :=replace(new_str, "m", ",")
    new_str3 :=replace(new_str2, "s", ",")
    split_aux := split(new_str3, ",")
    seconds := to_number(split_aux[0])*3600 + to_number(split_aux[1])*60 + to_number(split_aux[2]) 
}else = seconds {
	regex.match("^(\\d{1,3}[m])$", time)
    seconds := to_number(trim_suffix(time, "m") )*60  
}else = seconds {
	regex.match("^(\\d{1,3}[m])(\\d{1,3}[s])$", time)
    new_str := replace(time, "m", ",")
    new_str2 := replace(new_str, "s", ",")
    split_aux := split(new_str2, ",")
    seconds := to_number(split_aux[0])*60 + to_number(split_aux[1]) 
}else = seconds {
	regex.match("^(\\d{1,3}[s])$", time)
    seconds := to_number(trim_suffix(time, "s"))   
}

hasValidTimeValue(container, flag) {
	command := container.command
	startswith(command[a], flag)
	flag_value := split(command[a], "=")[1]
	regex.match("^(\\d{1,3}[h])(\\d{1,3}[m])?(\\d{1,3}[s])?$|^(\\d{1,3}[m])(\\d{1,3}[s])?$|^(\\d{1,3}[s])$", flag_value)
	
} else {
	args := container.args
	startswith(args[a], flag)
	flag_value := split(args[a], "=")[1]
	regex.match("^(\\d{1,3}[h])(\\d{1,3}[m])?(\\d{1,3}[s])?$|^(\\d{1,3}[m])(\\d{1,3}[s])?$|^(\\d{1,3}[s])$", flag_value)
}
