package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
	not checkPublicAccessBlockConfiguration(resource.Properties.PublicAccessBlockConfiguration)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PublicAccessBlockConfiguration", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.PublicAccessBlockConfiguration' is setted and configuration has value true",
		"keyActualValue": "'Resources.Properties.PublicAccessBlockConfiguration' is not setted or configuration has value false ",
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
		"keyExpectedValue": "'Resources.Properties.PublicAccessBlockConfiguration' is setted and configuration has value true ",
		"keyActualValue": "'Resources.Properties.WebsiteConfiguration' is configured",
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
