package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EC2::Instance"

	properties := resource.Properties
	subnetName := properties.NetworkInterfaces[j].SubnetId
	subNetObj := document.Resources[subnetName]
	not common_lib.valid_key(subNetObj.Properties, "VpcId")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [subnetName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.VpcId should be defined", [subnetName]),
		"keyActualValue": sprintf("Resources.%s.Properties.VpcId is undefined", [subnetName]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EC2::Instance"

	properties := resource.Properties
	not common_lib.valid_key(properties, "NetworkInterfaces")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.NetworkInterfaces should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.NetworkInterfaces is undefined", [key]),
	}
}
