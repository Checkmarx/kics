package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

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
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider", [cp_lib.getPath(path), resource.metadata.name]),
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
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.management", [cp_lib.getPath(path), resource.metadata.name]),
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
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.management.autoRepair", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "autoRepair should be set to true",
		"keyActualValue": "autoRepair is set to false",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider","management", "autoRepair"]),
	}
}
