package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
    object.get(resource, "Properties", "undefined") != "undefined"
    object.get(resource.Properties, "VersioningConfiguration", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.VersioningConfiguration is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.VersioningConfiguration is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
	resource.Properties.VersioningConfiguration.Status == "Suspended"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.VersioningConfiguration.Status", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.VersioningConfiguration.Status is set to Enabled", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.VersioningConfiguration.Status is set to Suspended", [name]),
	}
}
