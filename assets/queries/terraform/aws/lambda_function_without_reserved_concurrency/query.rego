package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_lambda_function[name]
    not common_lib.valid_key(resource, "reserved_concurrent_executions")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_lambda_function",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_lambda_function[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_lambda_function[%s].reserved_concurrent_executions should be set", [name]),
        "keyActualValue": sprintf("aws_lambda_function[%s].reserved_concurrent_executions is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_lambda_function", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_lambda_function[name]
    resource.reserved_concurrent_executions == -1
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_lambda_function",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_lambda_function[%s].reserved_concurrent_executions", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_lambda_function[%s].reserved_concurrent_executions should be >= 0 to limit concurrency", [name]),
        "keyActualValue": sprintf("aws_lambda_function[%s].reserved_concurrent_executions is -1 (no limit)", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_lambda_function", name, "reserved_concurrent_executions"], []),
    }
}
