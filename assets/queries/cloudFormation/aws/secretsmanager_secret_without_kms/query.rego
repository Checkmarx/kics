package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SecretsManager::Secret"
	
    res := is_kms_key_id_not_defined(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KmsKeyId' should be defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KmsKeyId' is undefined or null", [name]),
        "searchLine": res["sl"],
	}
}

is_kms_key_id_not_defined(resource, name)  = res {
    common_lib.valid_key(resource.Properties, "KmsKeyId")
    resource.Properties.KmsKeyId == ""

    res := {
        "sk": sprintf("Resources.%s.Properties.KmsKeyId", [name]),
        "it": "IncorrectValue",
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "KmsKeyId"], []),
    }
} else = res {
    not common_lib.valid_key(resource.Properties, "KmsKeyId")
    
    res := {
        "sk": sprintf("Resources.%s.Properties", [name]),
        "it": "MissingAttribute",
        "sl": common_lib.build_search_line(["Resources", name, "Properties"], []),
    }
}