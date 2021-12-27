package Cx

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.Resources[name]
	properties := resource.Properties
	resource.Type == "AWS::S3::Bucket"
	properties.AccessControl == "PublicReadWrite"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.AccessControl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 bucket should not have a public readable and writeble ACL",
		"keyActualValue": sprintf("S3 bucket named '%s' has ACL set to '%s'", [object.get(resource.Properties, "BucketName", "undefined"), properties.AccessControl]),
	}
}
