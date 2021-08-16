package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource[name]
	name == "aws_instance"
	res := resource[m]
	res.ebs_optimized == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance[{{%s}}].ebs_optimized", [m]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_instance.ebs_optimized is set to true",
		"keyActualValue": "aws_instance.ebs_optimized is set to false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[name]
	name == "aws_instance"
	res := resource[m]
	not common_lib.valid_key(res, "ebs_optimized")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance[{{%s}}]", [m]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_instance.ebs_optimized is set to true",
		"keyActualValue": "aws_instance.ebs_optimized is missing",
	}
}
