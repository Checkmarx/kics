package Cx

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
	searchkey := createSearchKey(name2, taskDef.Properties.ContainerDefinitions[_])

	result := {
		"documentId": input.document[i].id,
		"searchKey": searchkey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Memory' doesn't have incorrect values", [name2]),
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
	not contains(cpuMem, cpu)
	searchkey := createSearchKey(name2, taskDef.Properties.ContainerDefinitions[_])

	result := {
		"documentId": input.document[i].id,
		"searchKey": searchkey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Cpu' doesn't have incorrect values", [name2]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ContainerDefinitions.Cpu' has incorrect value", [name2]),
	}
}

checkMemory(res, memory) {
	cpuMem := memory[res.Properties.ContainerDefinitions[_].Cpu]
	mem := res.Properties.ContainerDefinitions[_].Memory
	not contains(cpuMem, mem)
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

createSearchKey(a, b) = search {
	not b.Name.Ref
	search := sprintf("Resources.%s.Properties.ContainerDefinitions.Name=%s", [a, b.Name])
}

createSearchKey(a, b) = search {
	b.Name.Ref
	search := sprintf("Resources.%s.Properties.ContainerDefinitions.Name=%s", [a, b.Name.Ref])
}
