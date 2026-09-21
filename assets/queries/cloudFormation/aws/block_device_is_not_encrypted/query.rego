package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

supported_resources := {"AWS::EC2::Instance", "AWS::AutoScaling::LaunchConfiguration"}

CxPolicy[result] {
    document := input.document[i]
    resource := document.Resources[name]
    resource.Type == supported_resources[_]

    res := prepare_issue(resource, name)

    result := { 
        "documentId": document.id,
        "resourceType": resource.Type,
        "resourceName": cf_lib.get_resource_name(resource, name),
        "searchKey": res["sk"],
        "issueType": res["it"],
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
        "searchLine": res["sl"],
    }
}

prepare_issue(resource, name) = res {
    common_lib.valid_key(resource.Properties, "BlockDeviceMappings")

    block := resource.Properties.BlockDeviceMappings[idx]
    common_lib.valid_key(block, "Ebs")

    common_lib.valid_key(block.Ebs, "Encrypted")
    not cf_lib.isCloudFormationTrue(block.Ebs.Encrypted)

    res := {
        "sk": sprintf("Resources.%s.Properties.BlockDeviceMappings[%d].Ebs.Encrypted", [name, idx]),
        "it": "IncorrectValue",
        "kev": sprintf("'BlockDeviceMappings[%d].Ebs.Encrypted' should be defined to 'true'", [idx]),
        "kav": sprintf("'BlockDeviceMappings[%d].Ebs.Encrypted' is not defined to 'true'", [idx]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "BlockDeviceMappings", idx, "Ebs", "Encrypted"], []),
    }
} else = res {
    common_lib.valid_key(resource.Properties, "BlockDeviceMappings")

    block := resource.Properties.BlockDeviceMappings[idx]
    common_lib.valid_key(block, "Ebs")
    not common_lib.valid_key(block.Ebs, "Encrypted")

    res := {
        "sk": sprintf("Resources.%s.Properties.BlockDeviceMappings[%d].Ebs", [name, idx]),
        "it": "MissingAttribute",
        "kev": sprintf("'BlockDeviceMappings[%d].Ebs.Encrypted' should be defined to 'true'", [idx]),
        "kav": sprintf("'BlockDeviceMappings[%d].Ebs.Encrypted' is not defined", [idx]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "BlockDeviceMappings", idx, "Ebs"], []),
    }
} 
