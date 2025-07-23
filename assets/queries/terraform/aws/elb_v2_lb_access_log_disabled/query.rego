package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_lb[name]

    not common_lib.valid_key(resource, "access_logs")  

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_lb",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_lb", name),
        "searchKey": sprintf("aws_lb[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'access_logs' should be defined and enabled",
        "keyActualValue": "'access_logs' is undefined",
        "searchLine": common_lib.build_search_line(["resource", "aws_lb", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_lb[name]

    not common_lib.valid_key(resource.access_logs, "enabled")  

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_lb",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_lb", name),
        "searchKey": sprintf("aws_lb[%s].access_logs", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'access_logs' should be defined and enabled",
        "keyActualValue": "'access_logs' is not enabled",
        "searchLine": common_lib.build_search_line(["resource", "aws_lb", name, "access_logs"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_lb[name]

    resource.access_logs.enabled != true

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_lb",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_lb", name),
        "searchKey": sprintf("aws_lb[%s].access_logs.enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'access_logs' should be defined and enabled",
        "keyActualValue": "'access_logs' is not enabled",
        "searchLine": common_lib.build_search_line(["resource", "aws_lb", name, "access_logs", "enabled"], []),
    }
}

