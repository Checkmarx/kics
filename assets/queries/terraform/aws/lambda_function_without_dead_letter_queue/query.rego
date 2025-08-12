package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document
	lambda := document[i].resource.aws_lambda_function[name]

    res := is_dead_letter_queue_undefined_or_empty(lambda, name)

	result := {
		"documentId": document[i].id,
		"resourceType": "aws_lambda_function",
		"resourceName": tf_lib.get_resource_name(lambda, name),
		"searchKey": res["sk"],
		"issueType": "MissingAttribute",
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
	}
}

is_dead_letter_queue_undefined_or_empty(resource, name) = res {
    not common_lib.valid_key(resource, "dead_letter_config")

    res := {
        "sk": sprintf("aws_lambda_function[%s]", [name]),
        "kev": sprintf("'aws_lambda_function[%s].dead_letter_config' should be defined and not null", [name]),
        "kav": sprintf("'aws_lambda_function[%s].dead_letter_config' is undefined or null", [name]),
    }
} else = res {
    common_lib.valid_key(resource.dead_letter_config, "target_arn")
    resource.dead_letter_config.target_arn == ""

    res := {
        "sk": sprintf("aws_lambda_function[%s].dead_letter_config.target_arn", [name]),
        "kev": sprintf("'aws_lambda_function[%s].dead_letter_config.target_arn' should be defined and not empty", [name]),
        "kav": sprintf("'aws_lambda_function[%s].dead_letter_config.target_arn' is empty", [name]),
    }
}