package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_cloudformation_stack[name]
    not common_lib.valid_key(resource, "termination_protection")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_cloudformation_stack",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_cloudformation_stack[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_cloudformation_stack[%s].termination_protection should be true", [name]),
        "keyActualValue": sprintf("aws_cloudformation_stack[%s].termination_protection is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_cloudformation_stack", name], []),
        "remediation": "termination_protection = true",
        "remediationType": "addition",
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_cloudformation_stack[name]
    resource.termination_protection == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_cloudformation_stack",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_cloudformation_stack[%s].termination_protection", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_cloudformation_stack[%s].termination_protection should be true", [name]),
        "keyActualValue": sprintf("aws_cloudformation_stack[%s].termination_protection is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_cloudformation_stack", name, "termination_protection"], []),
        "remediation": json.marshal({
            "before": "false",
            "after": "true",
        }),
        "remediationType": "replacement",
    }
}
