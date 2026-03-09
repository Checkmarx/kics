package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.aws_emr_security_configuration[name]
    cfg := json.unmarshal(resource.configuration)
    enc := cfg.EncryptionConfiguration
    not common_lib.valid_key(enc, "AtRestEncryptionConfiguration")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_emr_security_configuration",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_emr_security_configuration[%s].configuration", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_emr_security_configuration[%s] should define AtRestEncryptionConfiguration with LocalDiskEncryptionConfiguration", [name]),
        "keyActualValue": sprintf("aws_emr_security_configuration[%s] has no AtRestEncryptionConfiguration", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_emr_security_configuration", name, "configuration"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.aws_emr_security_configuration[name]
    cfg := json.unmarshal(resource.configuration)
    enc := cfg.EncryptionConfiguration
    at_rest := enc.AtRestEncryptionConfiguration
    not common_lib.valid_key(at_rest, "LocalDiskEncryptionConfiguration")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_emr_security_configuration",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("aws_emr_security_configuration[%s].configuration", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_emr_security_configuration[%s] should define LocalDiskEncryptionConfiguration", [name]),
        "keyActualValue": sprintf("aws_emr_security_configuration[%s].AtRestEncryptionConfiguration is missing LocalDiskEncryptionConfiguration", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_emr_security_configuration", name, "configuration"], []),
    }
}
