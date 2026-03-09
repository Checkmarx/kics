package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_apigatewayv2_api[name]
    cors := resource.cors_configuration
    origins := cors.allow_origins
    origins[_] == "*"
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_apigatewayv2_api",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_apigatewayv2_api[%s].cors_configuration.allow_origins", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_apigatewayv2_api[%s].cors_configuration.allow_origins should not contain wildcard '*'", [name]),
        "keyActualValue": sprintf("aws_apigatewayv2_api[%s].cors_configuration.allow_origins contains wildcard '*'", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_apigatewayv2_api", name, "cors_configuration", "allow_origins"], []),
    }
}
