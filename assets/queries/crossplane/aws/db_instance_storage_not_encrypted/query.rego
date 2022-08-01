package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "database.aws.crossplane.io")
	resource.kind == "RDSInstance"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "storageEncrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "storageEncrypted should be defined and set to true",
		"keyActualValue": "storageEncrypted is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "database.aws.crossplane.io")
	resource.kind == "RDSInstance"
	forProvider := resource.spec.forProvider

	forProvider.storageEncrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.storageEncrypted", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "storageEncrypted should be set to true",
		"keyActualValue": "storageEncrypted is set to false",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "storageEncrypted"]),
	}
}
