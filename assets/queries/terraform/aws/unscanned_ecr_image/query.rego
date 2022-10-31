package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository[name]
	imageScan := resource.image_scanning_configuration
	not imageScan.scan_on_push

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ecr_repository",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ecr_repository[%s].image_scanning_configuration.scan_on_push", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_ecr_repository", name, "image_scanning_configuration", "scan_on_push"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_ecr_repository[%s].image_scanning_configuration.scan_on_push is true", [name]),
		"keyActualValue": sprintf("aws_ecr_repository[%s].image_scanning_configuration.scan_on_push is false", [name]),
		"enabled": imageScan.scan_on_push,
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
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
		"searchLine": common_lib.build_search_line(["resource", "aws_ecr_repository", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_ecr_repository[%s].image_scanning_configuration should be defined", [name]),
		"keyActualValue": sprintf("aws_ecr_repository[%s].image_scanning_configuration is undefined", [name]),
		"remediation": "image_scanning_configuration { \n\t\tscan_on_push = true \n\t}",
		"remediationType": "addition",
	}
}
