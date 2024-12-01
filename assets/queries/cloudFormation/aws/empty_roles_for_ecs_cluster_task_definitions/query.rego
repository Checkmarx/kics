package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ECS::Service"

	isInCluster(resource, document)

	not common_lib.valid_key(resource.Properties, "TaskDefinition")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.TaskDefinition' should be set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.TaskDefinition' is undefined", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ECS::Service"

	isInCluster(resource, document)

	taskDefinition := resource.Properties.TaskDefinition

	existsTaskDefinition(taskDefinition, document) == null

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.TaskDefinition", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Taskdefinition' refers to a valid TaskDefinition", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Taskdefinition' does not refers to a valid TaskDefinition", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ECS::Service"

	isInCluster(resource, document)

	taskDefinition := resource.Properties.TaskDefinition

	taskDef := existsTaskDefinition(taskDefinition, document)
	taskDef != null

	hasTaskRole(taskDef) == false

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.TaskDefinition", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.TaskDefinition' refers to a TaskDefinition with Role", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.TaskDefinition' does not refer to a TaskDefinition with Role", [name]),
	}
}

isInCluster(service, document) {
	cluster := service.Properties.Cluster
	is_string(cluster)
	document.Resources[cluster]
} else {
	cluster := service.Properties.Cluster
	is_object(cluster)
	common_lib.valid_key(cluster, "Ref")
} else = false

existsTaskDefinition(taskDefName, document) = taskDef {
	is_string(taskDefName)
	document.Resources[taskDefName].Type == "AWS::ECS::TaskDefinition"
	taskDef := document.Resources[taskDefName]
} else = taskDef {
	is_object(taskDefName)
	ref := taskDefName.Ref
	document.Resources[ref].Type == "AWS::ECS::TaskDefinition"
	taskDef := document.Resources[ref]
} else = null

hasTaskRole(taskDef) {
	common_lib.valid_key(taskDef.Properties, "TaskRoleArn")
} else = false
