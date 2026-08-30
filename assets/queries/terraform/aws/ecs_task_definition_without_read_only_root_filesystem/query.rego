package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_ecs_task_definition[name]
    defs := json.unmarshal(resource.container_definitions)
    container := defs[_]
    not common_lib.valid_key(container, "readonlyRootFilesystem")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_ecs_task_definition",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_ecs_task_definition[%s].container_definitions", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_ecs_task_definition[%s] container_definitions should have readonlyRootFilesystem: true", [name]),
        "keyActualValue": sprintf("aws_ecs_task_definition[%s] has a container without readonlyRootFilesystem defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_ecs_task_definition", name, "container_definitions"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_ecs_task_definition[name]
    defs := json.unmarshal(resource.container_definitions)
    container := defs[_]
    container.readonlyRootFilesystem == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_ecs_task_definition",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_ecs_task_definition[%s].container_definitions", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_ecs_task_definition[%s] containers should have readonlyRootFilesystem: true", [name]),
        "keyActualValue": sprintf("aws_ecs_task_definition[%s] has a container with readonlyRootFilesystem: false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_ecs_task_definition", name, "container_definitions"], []),
    }
}
