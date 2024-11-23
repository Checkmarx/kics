package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	kind := document.kind
	kind == "Secret"

	not hasExternalStorageSecretProviderClass(input)

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}", [document.metadata.name]),
		"keyExpectedValue": "External secret storage should be used",
		"keyActualValue": "External secret storage is not in use",
		"searchLine": common_lib.build_search_line(["metadata", "name"], []),
	}
}

hasExternalStorageSecretProviderClass(input_data) {
	some document in input_data.document
	document.kind == "SecretProviderClass"
	spec := document.spec
	common_lib.valid_key(spec, "provider")
}
