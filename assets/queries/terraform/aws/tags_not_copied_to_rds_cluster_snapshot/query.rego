package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

supported_resources := {"aws_rds_cluster", "aws_db_instance"}

CxPolicy[result] {
    resource := input.document[i].resource[supported_resources[k]][name]

    resource.copy_tags_to_snapshot == false 

    result := {
        "documentId": input.document[i].id,
        "resourceType": supported_resources[k],
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("%s[%s].copy_tags_to_snapshot", [supported_resources[k], name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'%s[%s].copy_tags_to_snapshot' should be set to true", [supported_resources[k], name]),
        "keyActualValue": sprintf("'%s[%s].copy_tags_to_snapshot' is set to false", [supported_resources[k], name]),
        "searchLine": common_lib.build_search_line(["resource", supported_resources[k], name, "copy_tags_to_snapshot"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource[supported_resources[k]][name]

    not common_lib.valid_key(resource, "copy_tags_to_snapshot")

    result := {
        "documentId": input.document[i].id,
        "resourceType": supported_resources[k],
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("%s[%s]", [supported_resources[k], name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'%s[%s].copy_tags_to_snapshot' should be defined to true", [supported_resources[k], name]),
        "keyActualValue": sprintf("'%s[%s].copy_tags_to_snapshot' is not defined", [supported_resources[k], name]),
        "searchLine": common_lib.build_search_line(["resource", supported_resources[k], name], []),
    }
}