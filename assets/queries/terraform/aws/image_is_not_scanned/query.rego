package Cx

CxPolicy[result] {
	imageScan := input.document[i].resource.aws_ecr_repository[name].image_scanning_configuration
	not imageScan.scan_on_push

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository[%s].image_scanning_configuration.scan_on_push", [name]),
		"issueType": "IncorrectValued",
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
		"searchKey": sprintf("aws_ecr_repository[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_ecr_repository[%s].image_scanning_configuration is defined", [name]),
		"keyActualValue": sprintf("aws_ecr_repository[%s].image_scanning_configuration is undefined", [name]),
	}
}
