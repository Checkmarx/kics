package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
    resource := input.document[i].Resources[name]
    resource.Type == "AWS::EKS::Cluster"

    not common_lib.valid_key(resource.Properties, "EncryptionConfig")

    result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute", 
		"keyExpectedValue": "'EncryptionConfig' should be defined and not null",
		"keyActualValue": "'EncryptionConfig' is undefined or null",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
    res := input.document[i].Resources[name]
    res.Type == "AWS::EKS::Cluster"

	encryption_configs := res.Properties.EncryptionConfig
	resources := [r | cfg := encryption_configs[_]; r := cfg.Resources[_]]
    count({x | resource := resources[x]; resource == "secrets"}) == 0

    result := {
		"documentId": input.document[i].id,
		"resourceType": res.Type,
		"resourceName": cf_lib.get_resource_name(res, name),
		"searchKey": sprintf("Resources.%s.Properties.EncryptionConfig", [name]),
		"issueType": "IncorrectValue", 
		"keyExpectedValue": "'secrets' should be defined inside the Resources field",
		"keyActualValue": "'secrets' is undefined on the Resources field",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "EncryptionConfig"], [])
	}
}