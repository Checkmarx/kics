package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_wafv2_web_acl[name]
    acl_name := terra_lib.get_resource_name(resource, name)

    # Check there is no corresponding aws_wafv2_web_acl_logging_configuration
    not any_logging_config_exists(acl_name)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_wafv2_web_acl",
        "resourceName": acl_name,
        "searchKey": sprintf("aws_wafv2_web_acl[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_wafv2_web_acl[%s] should have an associated aws_wafv2_web_acl_logging_configuration", [name]),
        "keyActualValue": sprintf("aws_wafv2_web_acl[%s] has no logging configuration", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_wafv2_web_acl", name], []),
    }
}

any_logging_config_exists(acl_name) {
    _ := input.document[_].resource.aws_wafv2_web_acl_logging_configuration[_]
}
