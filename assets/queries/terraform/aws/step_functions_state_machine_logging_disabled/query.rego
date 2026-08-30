package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_sfn_state_machine[name]
    not common_lib.valid_key(resource, "logging_configuration")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_sfn_state_machine",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_sfn_state_machine[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_sfn_state_machine[%s].logging_configuration should be defined with level != OFF", [name]),
        "keyActualValue": sprintf("aws_sfn_state_machine[%s].logging_configuration is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_sfn_state_machine", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_sfn_state_machine[name]
    resource.logging_configuration.level == "OFF"
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_sfn_state_machine",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_sfn_state_machine[%s].logging_configuration.level", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_sfn_state_machine[%s].logging_configuration.level should be ALL, ERROR, or FATAL", [name]),
        "keyActualValue": sprintf("aws_sfn_state_machine[%s].logging_configuration.level is OFF", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_sfn_state_machine", name, "logging_configuration", "level"], []),
    }
}
