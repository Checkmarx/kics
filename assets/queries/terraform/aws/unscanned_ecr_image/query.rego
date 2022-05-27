package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository[name]
	imageScan := resource.image_scanning_configuration
	not imageScan.scan_on_push

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecr_repository",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecr_repository[%s].image_scanning_configuration.scan_on_push", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_ecr_repository[%s].image_scanning_configuration.scan_on_push is true", [name]),
		"keyActualValue": sprintf("aws_ecr_repository[%s].image_scanning_configuration.scan_on_push is false", [name]),
		"enabled": imageScan.scan_on_push,
	}
}

CxPolicy[result] {
	imageScan := input.document[i].resource.aws_ecr_repository[name]
	not imageScan.image_scanning_configuration

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecr_repository",
		"resourceName": tf_lib.get_resource_name(imageScan, name),
		"searchKey": sprintf("aws_ecr_repository[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_ecr_repository[%s].image_scanning_configuration is defined", [name]),
		"keyActualValue": sprintf("aws_ecr_repository[%s].image_scanning_configuration is undefined", [name]),
	}
}
