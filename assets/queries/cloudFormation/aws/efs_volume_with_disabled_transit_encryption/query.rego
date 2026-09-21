package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource_list := input.document[i].Resources
	resource := resource_list[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	volume := resource.Properties.Volumes[j]
	common_lib.valid_key(volume.EFSVolumeConfiguration, "TransitEncryption")
	volume.EFSVolumeConfiguration.TransitEncryption != "ENABLED"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption", [name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption should be enabled", [name, j]),
		"keyActualValue": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption is disabled", [name, j]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Volumes", j, "EFSVolumeConfiguration", "TransitEncryption"], []),
	}
}

CxPolicy[result] {
	resource_list := input.document[i].Resources
	resource := resource_list[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	volume := resource.Properties.Volumes[j]
	efsVolumeConfiguration := volume.EFSVolumeConfiguration
	efsVolumeConfiguration != null
	not common_lib.valid_key(efsVolumeConfiguration, "TransitEncryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration", [name, j]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption should be defined", [name, j]),
		"keyActualValue": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption is not defined (set to DISABLED by default)", [name, j]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Volumes", j, "EFSVolumeConfiguration"], []),
	}
}

CxPolicy[result] {
	resource_list := input.document[i].Resources
	resource := resource_list[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	volume := resource.Properties.Volumes[j]
	not common_lib.valid_key(volume, "EFSVolumeConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Volumes[%d]", [name, j]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration should be defined", [name, j]),
		"keyActualValue": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration is not defined", [name, j]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Volumes", j], []),
	}
}

CxPolicy[result] {
	resource_list := input.document[i].Resources
	resource := resource_list[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	not common_lib.valid_key(resource.Properties, "Volumes")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Volumes should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Volumes is not defined", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}
