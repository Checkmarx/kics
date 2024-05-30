package Cx

import data.generic.common as commonLib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	resource.Properties.LaunchType == "FARGATE"
	taskDef := input.document[i].Resources[name2]
	taskDef.Type == "AWS::ECS::TaskDefinition"

	memory := {
		256: {512, 1024, 2048},
		512: numbers.range(1024, 4096),
		1024: numbers.range(2048, 8192),
		2048: numbers.range(4096, 16384),
		4096: numbers.range(8192, 30720),
	}

	checkMemory(taskDef, memory) == true

    getkey := cf_lib.createSearchKey(taskDef.Properties.ContainerDefinitions[_])
    searchkey = sprintf("Resources.%s.Properties.ContainerDefinitions.Name%s", [name2, getkey])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": searchkey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Memory' shouldn't have incorrect values", [name2]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Memory' has incorrect value", [name2]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	resource.Properties.LaunchType == "FARGATE"
	taskDef := input.document[i].Resources[name2]
	taskDef.Type == "AWS::ECS::TaskDefinition"
	cpuMem := {256, 512, 1024, 2048, 4096}
	cpu := taskDef.Properties.ContainerDefinitions[_].Cpu
	not commonLib.inArray(cpuMem, cpu)
	getkey := cf_lib.createSearchKey(taskDef.Properties.ContainerDefinitions[_])
    searchkey := sprintf("Resources.%s.Properties.ContainerDefinitions.Name%s", [name2, getkey])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": searchkey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Cpu' shouldn't have incorrect values", [name2]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Cpu' has incorrect value", [name2]),
	}
}

checkMemory(res, memory) {
	cpuMem := memory[res.Properties.ContainerDefinitions[_].Cpu]
	mem := res.Properties.ContainerDefinitions[_].Memory
	not commonLib.inArray(cpuMem, mem)
}

checkMemory(res, memory) {
	cpuMem := memory[res.Properties.ContainerDefinitions[_].Cpu]
	mem := res.Properties.ContainerDefinitions[_].Memory
	checkRemainder(mem, res.Properties.ContainerDefinitions[_].Cpu)
}

contains(arr, elem) {
	arr[_] = elem
}

checkRemainder(mem, cpu) {
	not cpu == 256
	not mem % 1024 == 0
}


