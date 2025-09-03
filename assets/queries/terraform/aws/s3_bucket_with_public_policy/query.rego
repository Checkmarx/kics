package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] { 
	resources := input.document[i].resource
	
	account_level_status := prepare_account_level_status(resources)

	not account_level_status == "secure"

	res := prepare_issues(resources, account_level_status)

	result := {
		"documentId": input.document[i].id,
		"resourceType": res["resType"],
		"resourceName": res["resName"],
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
	}
}

prepare_issues(resources, account_level_status) = res {
	not common_lib.valid_key(resources, "aws_s3_bucket_public_access_block")
	account_level_status == "insecureNotDefined"
	account_level_resource := resources.aws_s3_account_public_access_block[name]

	res := {
		"resType": "aws_s3_account_public_access_block",
		"resName": tf_lib.get_resource_name(account_level_resource, name),
		"sk": sprintf("aws_s3_account_public_access_block[%s]", [name]),
		"it": "MissingAttribute",
		"kev": sprintf("'aws_s3_account_public_access_block[%s].block_public_policy' should be defined to true", [name]),
		"kav": sprintf("'aws_s3_account_public_access_block[%s].block_public_policy' is not defined (defaults to false)", [name]),
		"sl": common_lib.build_search_line(["resource", "aws_s3_account_public_access_block", name], []),
	}
} else = res {
	not common_lib.valid_key(resources, "aws_s3_bucket_public_access_block")
	account_level_status == "insecureFalse"
	account_level_resource := resources.aws_s3_account_public_access_block[name]

	res := {
		"resType": "aws_s3_account_public_access_block",
		"resName": tf_lib.get_resource_name(account_level_resource, name),
		"sk": sprintf("aws_s3_account_public_access_block[%s].block_public_policy", [name]),
		"it": "IncorrectValue",
		"kev": sprintf("'aws_s3_account_public_access_block[%s].block_public_policy' should be defined to true", [name]),
		"kav": sprintf("'aws_s3_account_public_access_block[%s].block_public_policy' is defined to false", [name]),
		"sl": common_lib.build_search_line(["resource", "aws_s3_account_public_access_block", name, "block_public_policy"], []),
	}
} else = res {
	common_lib.valid_key(resources, "aws_s3_bucket_public_access_block")
	bucket_level_resource := resources.aws_s3_bucket_public_access_block[name]
	common_lib.valid_key(bucket_level_resource, "block_public_policy")
	bucket_level_resource.block_public_policy == false 

	res := {
		"resType": "aws_s3_bucket_public_access_block",
		"resName": tf_lib.get_resource_name(bucket_level_resource, name),
		"sk": sprintf("aws_s3_bucket_public_access_block[%s].block_public_policy", [name]),
		"it": "IncorrectValue",
		"kev": sprintf("'aws_s3_bucket_public_access_block[%s].block_public_policy' should be defined to true", [name]),
		"kav": sprintf("'aws_s3_bucket_public_access_block[%s].block_public_policy' is defined to false", [name]),
		"sl": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name, "block_public_policy"], []),
	}
} else = res {
	common_lib.valid_key(resources, "aws_s3_bucket_public_access_block")
	bucket_level_resource := resources.aws_s3_bucket_public_access_block[name]
	not common_lib.valid_key(bucket_level_resource, "block_public_policy")

	res := {
		"resType": "aws_s3_bucket_public_access_block",
		"resName": tf_lib.get_resource_name(bucket_level_resource, name),
		"sk": sprintf("aws_s3_bucket_public_access_block[%s]", [name]),
		"it": "MissingAttribute",
		"kev": sprintf("'aws_s3_bucket_public_access_block[%s].block_public_policy' should be defined to true", [name]),
		"kav": sprintf("'aws_s3_bucket_public_access_block[%s].block_public_policy' is not defined (defaults to false)", [name]),
		"sl": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name], [])
	}
}

prepare_account_level_status(resources) = status{ # aws_s3_account_public_access_block resource block not defined
	not common_lib.valid_key(resources, "aws_s3_account_public_access_block")
	status := "unknown"
} else = status { # aws_s3_account_public_access_block resource block defined and block_public_policy explicitly set to true
	common_lib.valid_key(resources, "aws_s3_account_public_access_block")
	account_resource := resources.aws_s3_account_public_access_block[name]
	account_resource.block_public_policy == true
	status := "secure"
} else = status { # aws_s3_account_public_access_block resource block defined and block_public_policy not explicitly set to true (false)
	common_lib.valid_key(resources, "aws_s3_account_public_access_block")
	account_resource := resources.aws_s3_account_public_access_block[name]
	common_lib.valid_key(account_resource, "block_public_policy")
	account_resource.block_public_policy == false
	status := "insecureFalse"
} else = status { # aws_s3_account_public_access_block resource block defined and block_public_policy not explicitly set to true (not defined)
	common_lib.valid_key(resources, "aws_s3_account_public_access_block")
	account_resource := resources.aws_s3_account_public_access_block[name]
	not common_lib.valid_key(account_resource, "block_public_policy")
	status := "insecureNotDefined"
}