package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

supported_resources := {"AWS::RDS::DBInstance", "AWS::RDS::DBCluster"}

CxPolicy[result] {
    resource := input.document[i].Resources[name]
    resource.Type == supported_resources[_]

    properties := resource.Properties 
    cf_lib.isCloudFormationFalse(properties.CopyTagsToSnapshot)

    result := {
        "documentId": input.document[i].id,
        "resourceType": resource.Type,
        "resourceName": cf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("Resources.%s.Properties.CopyTagsToSnapshot", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'Resources.%s.Properties.CopyTagsToSnapshot' should be set to true", [name]),
        "keyActualValue": sprintf("'Resources.%s.Properties.CopyTagsToSnapshot' is set to false", [name]),
        "searchLine": common_lib.build_search_line(["Resources", name, "Properties", "CopyTagsToSnapshot"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].Resources[name]
    resource.Type == supported_resources[_]

    properties := resource.Properties 
    not common_lib.valid_key(properties, "CopyTagsToSnapshot")

    result := {
        "documentId": input.document[i].id,
        "resourceType": resource.Type,
        "resourceName": cf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("Resources.%s.Properties", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'Resources.%s.Properties.CopyTagsToSnapshot' should be set to true", [name]),
        "keyActualValue": sprintf("'Resources.%s.Properties.CopyTagsToSnapshot' is not defined", [name]),
        "searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
    }
}