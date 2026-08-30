package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_cognito_user_pool[name]
    not common_lib.valid_key(resource, "user_pool_add_ons")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_cognito_user_pool",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_cognito_user_pool[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_cognito_user_pool[%s].user_pool_add_ons.advanced_security_mode should be ENFORCED or AUDIT", [name]),
        "keyActualValue": sprintf("aws_cognito_user_pool[%s].user_pool_add_ons is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_cognito_user_pool", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_cognito_user_pool[name]
    resource.user_pool_add_ons.advanced_security_mode == "OFF"
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_cognito_user_pool",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_cognito_user_pool[%s].user_pool_add_ons.advanced_security_mode", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_cognito_user_pool[%s].user_pool_add_ons.advanced_security_mode should be ENFORCED or AUDIT", [name]),
        "keyActualValue": sprintf("aws_cognito_user_pool[%s].user_pool_add_ons.advanced_security_mode is OFF", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_cognito_user_pool", name, "user_pool_add_ons", "advanced_security_mode"], []),
    }
}
