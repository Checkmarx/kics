package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "container.gcp.crossplane.io")
	resource.kind == "NodePool"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "management")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "management should be defined with autoRepair set to true",
		"keyActualValue": "management is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "container.gcp.crossplane.io")
	resource.kind == "NodePool"
	forProvider := resource.spec.forProvider

	management := forProvider.management
	not common_lib.valid_key(management, "autoRepair")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%s.metadata.name={{%s}}.spec.forProvider.management", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "autoRepair should be defined and set to true",
		"keyActualValue": "autoRepair is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider","management"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "container.gcp.crossplane.io")
	resource.kind == "NodePool"
	forProvider := resource.spec.forProvider

	management := forProvider.management
	management.autoRepair == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.management.autoRepair", [common_lib.concat_path(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "autoRepair should be set to true",
		"keyActualValue": "autoRepair is set to false",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider","management", "autoRepair"]),
	}
}
