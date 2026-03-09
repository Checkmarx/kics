package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_lambda_function[name]
    not resource.vpc_config
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_lambda_function",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_lambda_function[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_lambda_function[%s].vpc_config should be defined", [name]),
        "keyActualValue": sprintf("aws_lambda_function[%s].vpc_config is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_lambda_function", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_lambda_function[name]
    vpc := resource.vpc_config
    count(vpc.subnet_ids) == 0
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_lambda_function",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_lambda_function[%s].vpc_config.subnet_ids", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_lambda_function[%s].vpc_config.subnet_ids should contain at least one subnet", [name]),
        "keyActualValue": sprintf("aws_lambda_function[%s].vpc_config.subnet_ids is empty", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_lambda_function", name, "vpc_config", "subnet_ids"], []),
    }
}
