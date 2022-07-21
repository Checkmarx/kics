package Cx

import data.generic.common as common_lib

validValues = [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "cloudwatchlogs.aws.crossplane.io")
	resource.kind == "LogGroup"
	retention := resource.spec.forProvider.retentionInDays

	not common_lib.inArray(validValues, retention)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": "spec.forProvider.ingress.retentionInDays",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "retentioninDays should be set to a valid value",
		"keyActualValue": "retentioninDays is set to a invalid value",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], ["retentionInDays"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "cloudwatchlogs.aws.crossplane.io")
	resource.kind == "LogGroup"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "retentionInDays")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": "spec.forProvider.ingress",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "retentioninDays should be set to a valid value",
		"keyActualValue": "retentioninDays is set to a invalid value",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "cloudwatchlogs.aws.crossplane.io")
	resourceList[j].base.kind == "LogGroup"
	retention := resourceList[j].base.spec.forProvider.retentionInDays
	not common_lib.inArray(validValues, retention)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.retentionInDays", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "retentioninDays should be set to a valid value",
		"keyActualValue": "retentioninDays is set to a invalid value",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], ["retentionInDays"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "cloudwatchlogs.aws.crossplane.io")
	resourceList[j].base.kind == "LogGroup"
	forProvider := resourceList[j].base.spec.forProvider
	not common_lib.valid_key(forProvider, "retentionInDays")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "retentioninDays should be set to a valid value",
		"keyActualValue": "retentioninDays is not set",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], []),
	}
}
