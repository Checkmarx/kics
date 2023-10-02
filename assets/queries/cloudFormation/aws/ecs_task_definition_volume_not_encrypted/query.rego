package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::TaskDefinition"
    efs := elem.Properties.volumes[index].efsVolumeConfiguration
    value := efs.TransitEncryption 
	not value == "ENABLED"

    result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(elem, key),
		"searchKey": sprintf("Resources.%s.Properties.volumes", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.volumes[%d].efsVolumeConfiguration.TransitEncryption' should be set to 'ENABLED'", [key, index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.volumes[%d].efsVolumeConfiguration.TransitEncryption' is set to '%s'", [key, index, value]),
		"searchLine": common_lib.build_search_line(["Resources",key,"Properties","volumes", index,"efsVolumeConfiguration","TransitEncryption"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::TaskDefinition"
    efs := elem.Properties.volumes[index].efsVolumeConfiguration
    not efs.TransitEncryption 

    result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(elem, key),
		"searchKey": sprintf("Resources.%s.Properties.volumes", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.volumes[%d].efsVolumeConfiguration.TransitEncryption' should be set to 'ENABLED'", [key, index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.volumes[%d].efsVolumeConfiguration.TransitEncryption' is not set", [key, index]),
		"searchLine": common_lib.build_search_line(["Resources",key,"Properties","volumes", index,"efsVolumeConfiguration"], []),
	}
}