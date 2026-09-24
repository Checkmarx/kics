package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_iam_role[name]
    not common_lib.valid_key(resource, "permissions_boundary")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_iam_role",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("resource.aws_iam_role[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_iam_role[%s].permissions_boundary is defined", [name]),
        "keyActualValue": sprintf("aws_iam_role[%s].permissions_boundary is undefined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_iam_role", name], []),
    }
}
