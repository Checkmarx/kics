package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_route53_zone[name]
    not any_query_log_exists

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_route53_zone",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_route53_zone[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_route53_zone[%s] should have an associated aws_route53_query_log resource", [name]),
        "keyActualValue": sprintf("aws_route53_zone[%s] has no query logging configured", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_route53_zone", name], []),
    }
}

any_query_log_exists {
    _ := input.document[_].resource.aws_route53_query_log[_]
}
