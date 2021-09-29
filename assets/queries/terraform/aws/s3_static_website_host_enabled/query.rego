package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	count(resource.website) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.aws_s3_bucket[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_s3_bucket[%s].website doesn't have static websites inside", [name]),
		"keyActualValue": sprintf("resource.aws_s3_bucket[%s].website does have static websites inside", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "website"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "website")
	
	count(module[keyToCheck]) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'website' doesn't have static websites inside",
		"keyActualValue": "'website' does have static websites inside",
		"searchLine": common_lib.build_search_line(["module", name, "website"], []),
	}
}
