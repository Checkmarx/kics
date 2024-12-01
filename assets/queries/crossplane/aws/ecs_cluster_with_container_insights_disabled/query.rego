package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "ecs.aws.crossplane.io")
	resource.kind == "Cluster"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "settings")

	result := {
		"documentId": docs.id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Cluster.spec.forProvider.settings should be defined and have a ClusterSetting which name is 'containerInsights' with 'enabled' value",
		"keyActualValue": "Cluster.spec.forProvider.settings is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
	}
}

CxPolicy[result] {
	some docs in input.document
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "ecs.aws.crossplane.io")
	resource.kind == "Cluster"
	forProvider := resource.spec.forProvider

	not container_insights(forProvider.settings)

	result := {
		"documentId": docs.id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.settings", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Cluster.spec.forProvider.settings should have a ClusterSetting which name is 'containerInsights' with 'enabled' value",
		"keyActualValue": "Cluster.spec.forProvider.settings doesn't have a ClusterSetting which name is 'containerInsights' with 'enabled' value",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "settings"]),
	}
}

container_insights(settings) {
	settings[0].name == "containerInsights"
	settings[0].value == "enabled"
}
