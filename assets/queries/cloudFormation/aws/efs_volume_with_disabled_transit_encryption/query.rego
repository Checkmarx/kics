package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::TaskDefinition"
    efs := elem.Properties.Volumes[index].EFSVolumeConfiguration
    value := efs.TransitEncryption 
	value != "ENABLED"

    result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(elem, key),
		"searchKey": sprintf("Resources.%s.Properties.Volumes.%d.EFSVolumeConfiguration.TransitEncryption", [key,index]),
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
	not common_lib.valid_key(efs, "TransitEncryption")

    result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(elem, key),
		"searchKey": sprintf("Resources.%s.Properties.Volumes.%d.EFSVolumeConfiguration", [key,index]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption' should be defined", [key, index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption' is not defined (set to DISABLED by default)", [key, index]),
		"searchLine": common_lib.build_search_line(["Resources",key,"Properties","Volumes", index,"EFSVolumeConfiguration"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::TaskDefinition"
    efs := elem.Properties.Volumes[index]
	not efs.EFSVolumeConfiguration

    result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(elem, key),
		"searchKey": sprintf("Resources.%s.Properties.Volumes.%d", [key,index]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration' should be defined", [key, index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration' is not defined", [key, index]),
		"searchLine": common_lib.build_search_line(["Resources",key,"Properties","Volumes", index], []),
	}
}