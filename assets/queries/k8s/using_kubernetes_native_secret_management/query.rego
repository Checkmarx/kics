package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
	kind == "Secret"
	
    not hasExternalStorageViaSecretStore(input)
    not hasExternalStorageSecretProviderClass(input)

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}", [document.metadata.name]),
		"keyExpectedValue": "External secret storage should be used",
		"keyActualValue": "External secret storage is not in use",
		"searchLine": common_lib.build_search_line(["metadata", "name"], [])
	}
}

hasExternalStorageViaSecretStore(input_data){
	document := input_data.document[i]
	document.kind == "SecretStore"
	provider := document.spec.provider[_]		
	common_lib.valid_key(provider.server, "url")
}

hasExternalStorageSecretProviderClass(input_data){
	document := input_data.document[i]
	document.kind == "SecretProviderClass"
	spec := document.spec
	common_lib.valid_key(spec, "provider")
}


