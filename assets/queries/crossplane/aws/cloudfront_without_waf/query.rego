package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig

	not common_lib.valid_key(destribution_config, "webACLID")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("spec.forProvider.distributionConfig", []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'webACLID' should be defined",
		"keyActualValue": "'webACLID' is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider", "distributionConfig"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	resourceList[j].base.kind == "Distribution"
	destribution_config := resourceList[j].base.spec.forProvider.distributionConfig

	not common_lib.valid_key(destribution_config, "webACLID")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.distributionConfig", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'webACLID' should be defined",
		"keyActualValue": "'webACLID' is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base","spec", "forProvider", "distributionConfig"], []),
	}
}
