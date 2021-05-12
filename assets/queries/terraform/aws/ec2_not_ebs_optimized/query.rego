package Cx

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
	object.get(res, "ebs_optimized", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance[{{%s}}]", [m]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_instance.ebs_optimized is set to true",
		"keyActualValue": "aws_instance.ebs_optimized is missing",
	}
}
