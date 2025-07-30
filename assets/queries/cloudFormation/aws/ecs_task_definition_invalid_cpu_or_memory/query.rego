package Cx

import data.generic.common as common_lib
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

	containerDefinition := taskDef.Properties.ContainerDefinitions[cd]
	checkMemory(containerDefinition, memory)

	getkey := cf_lib.createSearchKey(containerDefinition)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ContainerDefinitions.Name%s", [name2, getkey]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Memory' shouldn't have incorrect values", [name2]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Memory' has incorrect value", [name2]),
		"searchLine": common_lib.build_search_line(["Resources", name2, "Properties", "ContainerDefinitions", cd], ["Memory"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	resource.Properties.LaunchType == "FARGATE"

	taskDef := input.document[i].Resources[name2]
	taskDef.Type == "AWS::ECS::TaskDefinition"

	cpuMem := {256, 512, 1024, 2048, 4096}
	containerDefinition := taskDef.Properties.ContainerDefinitions[cd]
	cpu := containerDefinition.Cpu
	not common_lib.inArray(cpuMem, cpu)

	getkey := cf_lib.createSearchKey(containerDefinition)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ContainerDefinitions.Name%s", [name2, getkey]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Cpu' shouldn't have incorrect values", [name2]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Cpu' has incorrect value", [name2]),
		"searchLine": common_lib.build_search_line(["Resources", name2, "Properties", "ContainerDefinitions", cd], ["Cpu"]),
	}
}

checkMemory(containerDefinition, memory) {
	cpuMem := memory[containerDefinition.Cpu]
	mem := containerDefinition.Memory
	not common_lib.inArray(cpuMem, mem)
}

checkMemory(containerDefinition, memory) {
	cpuMem := memory[containerDefinition.Cpu]
	mem := containerDefinition.Memory
	checkRemainder(mem, containerDefinition.Cpu)
}

contains(arr, elem) {
	arr[_] = elem
}

checkRemainder(mem, cpu) {
	not cpu == 256
	not mem % 1024 == 0
}
