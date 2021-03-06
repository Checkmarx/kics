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
		"keyExpectedValue": "S3 bucket versioning is configured",
		"keyActualValue": "S3 bucket versioning is missing",
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
		"keyExpectedValue": "S3 bucket versioning is set to Enabled",
		"keyActualValue": "S3 bucket versioning is set to Suspended",
	}
}
