package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::Volume"

	not attachedToInstances(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s' should be attached to instances", [name]),
		"keyActualValue": sprintf("'Resources.%s' is not attached to instances", [name]),
	}
}

attachedToInstances(volumeName) {
	some va
	resource := input.document[i].Resources[va]
	resource.Type == "AWS::EC2::VolumeAttachment"
	refers(resource.Properties.VolumeId, volumeName)
}

refers(obj, name) {
	obj.Ref == name
}

refers(obj, name) {
	obj == name
}
