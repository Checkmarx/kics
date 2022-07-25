package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "elbv2.aws.crossplane.io")
	resource.kind == "Listener"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "sslPolicy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider", [resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "sslPolicy should be defined with a secure protocol or cipher",
		"keyActualValue": "sslPolicy is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "elbv2.aws.crossplane.io")
	resource.kind == "Listener"
	forProvider := resource.spec.forProvider

	policy:= forProvider.sslPolicy
	common_lib.weakCipher(policy)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.sslPolicy", [resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sslPolicy should use a secure protocol or cipher",
		"keyActualValue": "sslPolicy is using a weak cipher",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], ["sslPolicy"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "elbv2.aws.crossplane.io")
	resourceList[j].base.kind == "Listener"
	forProvider := resourceList[j].base.spec.forProvider
	not common_lib.valid_key(forProvider, "sslPolicy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "sslPolicy should be defined with a secure protocol or cipher",
		"keyActualValue": "sslPolicy is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "elbv2.aws.crossplane.io")
	resourceList[j].base.kind == "Listener"
	forProvider := resourceList[j].base.spec.forProvider
	
	policy:= forProvider.sslPolicy
	common_lib.weakCipher(policy)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sslPolicy should use a secure protocol or cipher",
		"keyActualValue": "sslPolicy is using a weak cipher",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], ["sslPolicy"]),
	}
}

