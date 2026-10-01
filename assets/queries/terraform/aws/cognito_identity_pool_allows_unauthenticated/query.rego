package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_cognito_identity_pool[name]
    resource.allow_unauthenticated_identities == true
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_cognito_identity_pool",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_cognito_identity_pool[%s].allow_unauthenticated_identities", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_cognito_identity_pool[%s].allow_unauthenticated_identities should be false", [name]),
        "keyActualValue": sprintf("aws_cognito_identity_pool[%s].allow_unauthenticated_identities is true", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_cognito_identity_pool", name, "allow_unauthenticated_identities"], []),
    }
}
