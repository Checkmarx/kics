package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::TaskDefinition"
    efs := elem.Properties.Volumes[index].EFSVolumeConfiguration
    value := efs.TransitEncryption 
	not value == "ENABLED"

    result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(elem, key),
		"searchKey": sprintf("Resources.%s.Properties.Volumes", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption' should be set to 'ENABLED'", [key, index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption' is set to '%s'", [key, index, value]),
		"searchLine": common_lib.build_search_line(["Resources",key,"Properties","Volumes", index,"EFSVolumeConfiguration","TransitEncryption"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::TaskDefinition"
    efs := elem.Properties.Volumes[index].EFSVolumeConfiguration
    not efs.TransitEncryption 

    result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(elem, key),
		"searchKey": sprintf("Resources.%s.Properties.Volumes", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption' should be set to 'ENABLED'", [key, index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption' is not set", [key, index]),
		"searchLine": common_lib.build_search_line(["Resources",key,"Properties","Volumes", index,"EFSVolumeConfiguration"], []),
	}
}