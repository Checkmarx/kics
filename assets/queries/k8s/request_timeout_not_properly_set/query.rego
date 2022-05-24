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
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--request-timeout flag should not be set to more than 300 seconds",
		"keyActualValue": "--request-timeout flag is set to more than 300 seconds",
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
	regex.match("^(\\d+[h])$", time)
    seconds := to_number(trim_suffix(time, "h") )*3600    
}else = seconds {
	regex.match("^(\\d+[h])(\\d+[m])$", time)
    hours := replace(time, "h", ",")
    minutes := replace(hours, "m", ",")
    time_array := split(minutes, ",")
    seconds := to_number(time_array[0])*3600 + to_number(time_array[1])*60
}else = seconds {
	regex.match("^(\\d+[h])(\\d+[s])$", time)
    hours := replace(time, "h", ",")
    secs := replace(hours, "s", ",")
    time_array := split(secs, ",")
    seconds := to_number(time_array[0])*3600 + to_number(time_array[1])
}else = seconds {
	regex.match("^(\\d+[h])(\\d+[m])(\\d+[s])$", time)
    hours := replace(time, "h", ",")
    minutes :=replace(hours, "m", ",")
    secs :=replace(minutes, "s", ",")
    time_array := split(secs, ",")
    seconds := to_number(time_array[0])*3600 + to_number(time_array[1])*60 + to_number(time_array[2]) 
}else = seconds {
	regex.match("^(\\d+[m])$", time)
    seconds := to_number(trim_suffix(time, "m") )*60  
}else = seconds {
	regex.match("^(\\d+[m])(\\d+[s])$", time)
    minutes := replace(time, "m", ",")
    secs := replace(minutes, "s", ",")
    time_array := split(secs, ",")
    seconds := to_number(time_array[0])*60 + to_number(time_array[1]) 
}else = seconds {
	regex.match("^(\\d+[s])$", time)
    seconds := to_number(trim_suffix(time, "s"))   
}
