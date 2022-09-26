package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
	kind == "Secret"
	
    not hasExternalStorageSecretProviderClass(input)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}", [document.metadata.name]),
		"keyExpectedValue": "External secret storage should be used",
		"keyActualValue": "External secret storage is not in use",
		"searchLine": common_lib.build_search_line(["metadata", "name"], [])
	}
}

hasExternalStorageSecretProviderClass(input_data){
	document := input_data.document[i]
	document.kind == "SecretProviderClass"
	spec := document.spec
	common_lib.valid_key(spec, "provider")
}


