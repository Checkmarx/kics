package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
	not checkPublicAccessBlockConfiguration(resource.Properties.PublicAccessBlockConfiguration)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PublicAccessBlockConfiguration' is set and configuration has value true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PublicAccessBlockConfiguration' is not set or configuration has value false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"

	checkWebsiteConfiguration(resource.Properties)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.WebsiteConfiguration' and 'Resources.%s.Properties.AcessControl' are undefined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.WebsiteConfiguration' or 'Resources.%s.Properties.AccessControl' are defined", [name]),
	}
}

checkPublicAccessBlockConfiguration(properties) {
	properties.BlockPublicAcls == true
	properties.BlockPublicPolicy == true
	properties.IgnorePublicAcls == true
	properties.RestrictPublicBuckets == true
}

checkWebsiteConfiguration(properties) {
	properties.WebsiteConfiguration != null
}

checkWebsiteConfiguration(properties) {
	properties.AccessControl != null
}
