package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	function := document.functions[name]

	encrypted := is_encrypted_function(function, document)

	bom_output = {
		"resource_type": "Serverless Function",
		"resource_name": name,
		"resource_accessibility": "unknown",
		"resource_encryption": encrypted,
		"resource_vendor": upper(sfw_lib.get_provider_name(document)),
		"resource_category": "Compute",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, "")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("function.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["function", name], []),
		"value": json.marshal(final_bom_output),
	}
}

is_encrypted_function(function, document) = encrypted {
	common_lib.valid_key(function, "kmsKeyArn")
    encrypted := "encrypted"
} else = encrypted {
    provider := document.provider
    common_lib.valid_key(provider, "kmsKeyArn")
    encrypted := "encrypted"
} else = encrypted {
    encrypted := "unencrypted"
}
