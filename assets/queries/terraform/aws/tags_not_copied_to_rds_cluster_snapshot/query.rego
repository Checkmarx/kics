package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_rds_cluster[name]

    resource.copy_tags_to_snapshot == false 

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_rds_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_rds_cluster[%s].copy_tags_to_snapshot", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'aws_rds_cluster[%s].copy_tags_to_snapshot' should be set to true", [name]),
        "keyActualValue": sprintf("'aws_rds_cluster[%s].copy_tags_to_snapshot' is set to false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_rds_cluster", name, "copy_tags_to_snapshot"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_rds_cluster[name]

    not common_lib.valid_key(resource, "copy_tags_to_snapshot")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_rds_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_rds_cluster[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'aws_rds_cluster[%s].copy_tags_to_snapshot' should be defined to true", [name]),
        "keyActualValue": sprintf("'aws_rds_cluster[%s].copy_tags_to_snapshot' is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_rds_cluster", name], []),
    }
}