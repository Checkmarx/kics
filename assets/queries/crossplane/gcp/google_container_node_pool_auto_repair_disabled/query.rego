package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "container.gcp.crossplane.io")
	resource.kind == "NodePool"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "management")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": "spec.forProvider",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "management should be defined with autoRepair set to true",
		"keyActualValue": "management is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "container.gcp.crossplane.io")
	resource.kind == "NodePool"
	forProvider := resource.spec.forProvider

	management := forProvider.management
	not common_lib.valid_key(management, "autoRepair")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": "spec.forProvider.management",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "autoRepair should be defined and set to true",
		"keyActualValue": "autoRepair is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], ["management"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "container.gcp.crossplane.io")
	resource.kind == "NodePool"
	forProvider := resource.spec.forProvider

	management := forProvider.management
	management.autoRepair == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": "spec.forProvider.management.autoRepair",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "autoRepair should be set to true",
		"keyActualValue": "autoRepair is set to false",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], ["management", "autoRepair"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "container.gcp.crossplane.io")
	resourceList[j].base.kind == "NodePool"
	forProvider := resourceList[j].base.spec.forProvider
	not common_lib.valid_key(forProvider, "management")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "management should be defined with autoRepair set to true",
		"keyActualValue": "management is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "container.gcp.crossplane.io")
	resourceList[j].base.kind == "NodePool"
	forProvider := resourceList[j].base.spec.forProvider
	management := forProvider.management
	not common_lib.valid_key(management, "autoRepair")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.management", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "autoRepair should be defined and set to true",
		"keyActualValue": "autoRepair is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], ["management"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "container.gcp.crossplane.io")
	resourceList[j].base.kind == "NodePool"
	forProvider := resourceList[j].base.spec.forProvider
	management := forProvider.management
	management.autoRepair == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.management.autoRepair", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "autoRepair should be set to true",
		"keyActualValue": "autoRepair is set to false",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], ["management" ,"autoRepair"]),
	}
}
