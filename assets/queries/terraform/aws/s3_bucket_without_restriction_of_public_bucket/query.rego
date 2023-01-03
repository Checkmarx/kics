package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

#default of restrict_public_buckets is false
CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	not common_lib.valid_key(pubACL, "restrict_public_buckets")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_public_access_block",
		"resourceName": tf_lib.get_resource_name(pubACL, name),
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].restrict_public_buckets", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'restrict_public_buckets' should equal 'true'",
		"keyActualValue": "'restrict_public_buckets' is missing",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name], []),
		"remediation": "restrict_public_buckets = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	pubACL.restrict_public_buckets == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_public_access_block",
		"resourceName": tf_lib.get_resource_name(pubACL, name),
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].restrict_public_buckets", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'restrict_public_buckets' should equal 'true'",
		"keyActualValue": "'restrict_public_buckets' is equal 'false'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name, "restrict_public_buckets"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "restrict_public_buckets")
	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'restrict_public_buckets' should equal 'true'",
		"keyActualValue": "'restrict_public_buckets' is missing",
		"searchLine": common_lib.build_search_line(["module", name], []),
		"remediation": sprintf("%s = true",[keyToCheck]),
		"remediationType": "addition",

	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "restrict_public_buckets")
	module[keyToCheck] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].restrict_public_buckets", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'restrict_public_buckets' should equal 'true'",
		"keyActualValue": "'restrict_public_buckets' is equal 'false'",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
