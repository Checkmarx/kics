package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	object.get(resource, "enabled", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].enabled is set to 'true'", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].enabled is not defined", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	resource.enabled == false

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].enabled is set to 'true'", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].enabled is configured as 'false'", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]

	object.get(resource, "origin", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].origin is defined", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].origin is not defined", [name]),
	}
}
