package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "neptune.aws.crossplane.io")
	resource.kind == "DBCluster"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "storageEncrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider", [resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "storageEncrypted should be defined and set to true",
		"keyActualValue": "storageEncrypted is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "neptune.aws.crossplane.io")
	resource.kind == "DBCluster"
	forProvider := resource.spec.forProvider

	forProvider.storageEncrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.storageEncrypted", [resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "storageEncrypted should be defined and set to true",
		"keyActualValue": "storageEncrypted is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], ["storageEncrypted"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "neptune.aws.crossplane.io")
	resourceList[j].base.kind == "DBCluster"
	forProvider := resourceList[j].base.spec.forProvider
	not common_lib.valid_key(forProvider, "storageEncrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "storageEncrypted should be defined and set to true",
		"keyActualValue": "storageEncrypted is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "neptune.aws.crossplane.io")
	resourceList[j].base.kind == "DBCluster"
	forProvider := resourceList[j].base.spec.forProvider
	
	forProvider.storageEncrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.storageEncrypted", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "storageEncrypted should be defined and set to true",
		"keyActualValue": "storageEncrypted is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], ["storageEncrypted"]),
	}
}
