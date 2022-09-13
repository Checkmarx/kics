package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "cloudfront.aws.crossplane.io")
	resource.kind == "Distribution"
	destribution_config := resource.spec.forProvider.distributionConfig
	destribution_config.enabled == true

	not common_lib.valid_key(destribution_config, "webACLID")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.distributionConfig", [cp_lib.getPath(path), resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'webACLID' should be defined",
		"keyActualValue": "'webACLID' is not defined",
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider", "distributionConfig"]),
	}
}
