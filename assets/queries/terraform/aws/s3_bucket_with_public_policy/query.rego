package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] { # checks account-level configurations
	pubACL := input.document[i].resource.aws_s3_account_public_access_block[name]

	res := prepare_issue_account(pubACL, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_account_public_access_block",
		"resourceName": tf_lib.get_resource_name(pubACL, name),
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
	}
}

CxPolicy[result] { # checks bucket-level-configurations
	resources := input.document[i].resource
	pubBucket := resources.aws_s3_bucket_public_access_block[name]
	
	not is_block_public_policy_defined_to_true_at_account_level(resources)

	res := prepare_issue_bucket(pubBucket, name)	

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_public_access_block",
		"resourceName": tf_lib.get_resource_name(pubBucket, name),
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
	}
}

is_block_public_policy_defined_to_true_at_account_level(resources) {
	common_lib.valid_key(resources, "aws_s3_account_public_access_block")
	resources.aws_s3_account_public_access_block[_].block_public_policy == true
}

prepare_issue_account(pubACL, name) = res {
	common_lib.valid_key(pubACL, "block_public_policy")
	not pubACL.block_public_policy == true

	res := {
		"sk": sprintf("aws_s3_account_public_access_block[%s].block_public_policy", [name]),
		"it": "IncorrectValue",
		"kev": sprintf("'aws_s3_account_public_access_block[%s].block_public_policy' should be set to 'true'", [name]),
		"kav": sprintf("'aws_s3_account_public_access_block[%s].block_public_policy' is not set to 'true'", [name]),
		"sl": common_lib.build_search_line(["resource", "aws_s3_account_public_access_block", name, "block_public_policy"], []),
	}
} else = res {
	not common_lib.valid_key(pubACL, "block_public_policy")

	res := {
		"sk": sprintf("aws_s3_account_public_access_block[%s]", [name]),
		"it": "MissingAttribute",
		"kev": sprintf("'aws_s3_account_public_access_block[%s]' should have the 'block_public_policy' field set to 'true'", [name]),
		"kav": sprintf("'aws_s3_account_public_access_block[%s]' does not have the 'block_public_policy' defined (defaults to 'false')", [name]),
		"sl": common_lib.build_search_line(["resource", "aws_s3_account_public_access_block", name], []),
	}
}

prepare_issue_bucket(pubBucket, name) = res {
	common_lib.valid_key(pubBucket, "block_public_policy")
	not pubBucket.block_public_policy == true

	res := {
		"sk": sprintf("aws_s3_bucket_public_access_block[%s].block_public_policy", [name]),
		"it": "IncorrectValue",
		"kev": sprintf("'aws_s3_bucket_public_access_block[%s].block_public_policy' should be set to 'true'", [name]),
		"kav": sprintf("'aws_s3_bucket_public_access_block[%s].block_public_policy' is not set to 'true'", [name]),
		"sl": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name, "block_public_policy"], []),
	}
} else = res {
	not common_lib.valid_key(pubBucket, "block_public_policy")

	res := {
		"sk": sprintf("aws_s3_bucket_public_access_block[%s]", [name]),
		"it": "MissingAttribute",
		"kev": sprintf("'aws_s3_bucket_public_access_block[%s]' should have the 'block_public_policy' field set to 'true'", [name]),
		"kav": sprintf("'aws_s3_bucket_public_access_block[%s]' does not have the 'block_public_policy' defined (defaults to 'false')", [name]),
		"sl": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name], []),
	}
}