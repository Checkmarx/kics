package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource_list := input.document[i].Resources
	resource := resource_list[name]
	resource.Type == "AWS::ECS::TaskDefinition"
    results := is_transit_encryption_disabled(resource,name)

    result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": results.sk,
		"issueType": results.issueT,
		"keyExpectedValue": results.kev,
		"keyActualValue": results.kav,
		"searchLine": results.sl,
	}
}

is_transit_encryption_disabled(taskDefinition, name) = res {
	volume := taskDefinition.Properties.Volumes[j]
    common_lib.valid_key(volume.EFSVolumeConfiguration, "TransitEncryption") 
    volume.EFSVolumeConfiguration.TransitEncryption != "ENABLED"
    res := {
		"sk": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption", [name, j]),
    	"issueT": "IncorrectValue",
    	"kev": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption should be enabled", [name, j]),
		"kav": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption is disabled", [name, j]),
		"sl" : common_lib.build_search_line(["Resources",name,"Properties","Volumes", j,"EFSVolumeConfiguration","TransitEncryption"], []),
    }
} else = res { 
	volume := taskDefinition.Properties.Volumes[j]
    efsVolumeConfiguration := volume.EFSVolumeConfiguration
    not common_lib.valid_key(efsVolumeConfiguration, "TransitEncryption")
    res := {
		"sk": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration", [name, j]),
    	"issueT": "MissingAttribute",
    	"kev": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption should be defined", [name, j]),
        "kav": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption is not defined (set to DISABLED by default)", [name, j]),
		"sl" : common_lib.build_search_line(["Resources",name,"Properties","Volumes", j,"EFSVolumeConfiguration"], []),
    }
} else = res {
	volume := taskDefinition.Properties.Volumes[j]
	not common_lib.valid_key(volume, "EFSVolumeConfiguration")
	res := {
		"sk": sprintf("Resources.%s.Properties.Volumes[%d]", [name, j]),
		"issueT": "MissingAttribute",
		"kev": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration should be defined", [name, j]),
		"kav": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration is not defined", [name, j]),
		"sl" : common_lib.build_search_line(["Resources",name,"Properties","Volumes", j], []),
	}
} else = res {
	not common_lib.valid_key(taskDefinition.Properties, "Volumes")
	res := {
		"sk": sprintf("Resources.%s.Properties", [name]),
		"issueT": "MissingAttribute",
		"kev": sprintf("Resources.%s.Properties.Volumes should be defined", [name]),
		"kav": sprintf("Resources.%s.Properties.Volumes is not defined", [name]),
		"sl" : common_lib.build_search_line(["Resources",name,"Properties"], []),
	}
} 

