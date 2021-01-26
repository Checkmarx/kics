package Cx

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::EFS::FileSystem"
	properties := resource.Properties
	properties.Encrypted == false
	object.get(properties, "KmsKeyId", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("EFS resource '%s' should have encryption enabled using KMS CMK customer-managed keys instead of AWS managed-keys", [name]),
		"keyActualValue": sprintf("EFS resource '%s' is not encrypted using KMS CMK customer-managed keys instead of AWS managed-keys", [name]),
	}
}
