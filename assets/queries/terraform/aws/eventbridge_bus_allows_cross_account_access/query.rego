package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_cloudwatch_event_bus_policy[name]
    doc := json.unmarshal(resource.policy)
    stmt := doc.Statement[_]
    principal := stmt.Principal
    is_string(principal)
    principal == "*"
    stmt.Effect == "Allow"
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_cloudwatch_event_bus_policy",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_cloudwatch_event_bus_policy[%s].policy", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_cloudwatch_event_bus_policy[%s].policy should restrict Principal to specific accounts", [name]),
        "keyActualValue": sprintf("aws_cloudwatch_event_bus_policy[%s].policy allows Principal '*' (any account)", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_cloudwatch_event_bus_policy", name, "policy"], []),
    }
}
