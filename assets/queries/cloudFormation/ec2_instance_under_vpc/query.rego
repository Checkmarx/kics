package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EC2::Instance"

	properties := resource.Properties
	subnetName := properties.NetworkInterfaces[j].SubnetId
	subNetObj := document.Resources[subnetName]
	object.get(subNetObj.Properties, "VpcId", "undefined") == "undefined"

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
	object.get(properties, "NetworkInterfaces", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.NetworkInterfaces should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.NetworkInterfaces is undefined", [key]),
	}
}
