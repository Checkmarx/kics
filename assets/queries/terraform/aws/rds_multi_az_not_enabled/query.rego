package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_db_instance[name]
    not common_lib.valid_key(resource, "multi_az")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_db_instance",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_db_instance[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_db_instance[%s].multi_az should be set to true", [name]),
        "keyActualValue": sprintf("aws_db_instance[%s].multi_az is not defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_db_instance[name]
    resource.multi_az == false
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_db_instance",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_db_instance[%s].multi_az", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_db_instance[%s].multi_az should be true", [name]),
        "keyActualValue": sprintf("aws_db_instance[%s].multi_az is false", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "multi_az"], []),
    }
}
