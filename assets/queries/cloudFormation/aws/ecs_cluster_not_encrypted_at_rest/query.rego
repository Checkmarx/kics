package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {  
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::Service"
	elem.Properties.Cluster
	taskdefinitionkey := getTaskDefinitionName(elem)
	taskDefinition := resource[taskdefinitionkey]

	count(taskDefinition.Properties.ContainerDefinitions) > 0
	res := is_transit_encryption_disabled(taskDefinition, taskdefinitionkey)
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(resource, key), 
		"searchKey": res["sk"],
		"issueType": res["issueT"],
		"keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::ECS::Service"
	elem.Properties.Cluster
	taskdefinitionkey := getTaskDefinitionName(elem)
	not common_lib.valid_key(resource, taskdefinitionkey)

	result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s", [taskdefinitionkey]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s should be defined", [taskdefinitionkey]),
		"keyActualValue": sprintf("Resources.%s is not defined.", [taskdefinitionkey]),
	}
}

is_transit_encryption_disabled(taskDefinition, taskdefinitionkey) = res {
	volume := taskDefinition.Properties.Volumes[j]
    common_lib.valid_key(volume.EFSVolumeConfiguration, "TransitEncryption") 
    volume.EFSVolumeConfiguration.TransitEncryption == "DISABLED"
    res := {
		"sk": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption", [taskdefinitionkey, j]),
    	"issueT": "IncorrectValue",
    	"kev": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption should be enabled", [taskdefinitionkey, j]),
		"kav": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption is disabled", [taskdefinitionkey, j]),
    }
} else = res { 
	volume := taskDefinition.Properties.Volumes[j]
    efsVolumeConfiguration := volume.EFSVolumeConfiguration
    not common_lib.valid_key(efsVolumeConfiguration, "TransitEncryption")
    res := {
		"sk": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration", [taskdefinitionkey, j]),
    	"issueT": "MissingAttribute",
    	"kev": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption should be defined", [taskdefinitionkey, j]),
        "kav": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption is not defined (set to DISABLED by default)", [taskdefinitionkey, j]),
    }
} else = res {
	volume := taskDefinition.Properties.Volumes[j]
	not common_lib.valid_key(volume, "EFSVolumeConfiguration")
	res := {
		"sk": sprintf("Resources.%s.Properties.Volumes[%d]", [taskdefinitionkey, j]),
		"issueT": "MissingAttribute",
		"kev": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration should be defined", [taskdefinitionkey, j]),
		"kav": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration is not defined", [taskdefinitionkey, j]),
	}
} else = res {
	not common_lib.valid_key(taskDefinition.Properties, "Volumes")
	res := {
		"sk": sprintf("Resources.%s.Properties", [taskdefinitionkey]),
		"issueT": "MissingAttribute",
		"kev": sprintf("Resources.%s.Properties.Volumes should be defined", [taskdefinitionkey]),
		"kav": sprintf("Resources.%s.Properties.Volumes is not defined", [taskdefinitionkey]),
	}
} 

getTaskDefinitionName(resource) := name {
	name := resource.Properties.TaskDefinition
	not common_lib.valid_key(name, "Ref")
} else := name {
	name := resource.Properties.TaskDefinition.Ref
}
