package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"

	isInCluster(resource)

	object.get(resource.Properties, "TaskDefinition", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.TaskDefinition' is set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.TaskDefinition' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"

	isInCluster(resource)

	object.get(resource.Properties, "TaskDefinition", "undefined") != "undefined"
	taskDefinition := resource.Properties.TaskDefinition

	existsTaskDefinition(taskDefinition) == null

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.TaskDefinition", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Taskdefinition' refers to a valid TaskDefinition", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Taskdefinition' does not refers to a valid TaskDefinition", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"

	isInCluster(resource)

	object.get(resource.Properties, "TaskDefinition", "undefined") != "undefined"
	taskDefinition := resource.Properties.TaskDefinition

	taskDef := existsTaskDefinition(taskDefinition)
	taskDef != null

	hasTaskRole(taskDef) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.TaskDefinition", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.TaskDefinition' refers to a TaskDefinition with Role", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.TaskDefinition' does not refer to a TaskDefinition with Role", [name]),
	}
}

isInCluster(service) {
	cluster := service.Properties.Cluster
	is_string(cluster)
	input.document[_].Resources[cluster]
} else {
	cluster := service.Properties.Cluster
	is_object(cluster)
	object.get(cluster, "Ref", "undefined") != "undefined"
} else = false {
	true
}

existsTaskDefinition(taskDefName) = taskDef {
	is_string(taskDefName)
	input.document[_].Resource[taskDefName].Type == "AWS::ECS::TaskDefinition"
	taskDef := input.document[_].Resource[taskDefName]
} else = taskDef {
	is_object(taskDefName)
	object.get(taskDefName, "Ref", "undefined") != "undefined"
	ref := object.get(taskDefName, "Ref", "undefined")
	input.document[_].Resource[ref].Type == "AWS::ECS::TaskDefinition"
	taskDef := input.document[_].Resource[ref]
} else = null {
	true
}

hasTaskRole(taskDef) {
	object.get(taskDef.Properties, "TaskRoleArn", "undefined") != "undefined"
} else = false {
	true
}
