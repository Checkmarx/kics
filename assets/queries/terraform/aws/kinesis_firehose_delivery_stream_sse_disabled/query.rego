package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]
    not common_lib.valid_key(resource, "server_side_encryption")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_kinesis_firehose_delivery_stream",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_kinesis_firehose_delivery_stream[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption should be enabled", [name]),
        "keyActualValue": sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_kinesis_firehose_delivery_stream", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]
    resource.server_side_encryption.enabled == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_kinesis_firehose_delivery_stream",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption.enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption.enabled should be true", [name]),
        "keyActualValue": sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption.enabled is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_kinesis_firehose_delivery_stream", name, "server_side_encryption", "enabled"], []),
    }
}
