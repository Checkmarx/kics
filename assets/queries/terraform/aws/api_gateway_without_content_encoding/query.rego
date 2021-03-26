package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_rest_api[name]

	not resource.minimum_compression_size

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_rest_api[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'minimum_compression_size' is set, greater than -1 and smaller than 10485760",
		"keyActualValue": "Attribute 'minimum_compression_size' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_rest_api[name]

	resource.minimum_compression_size < 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_rest_api[%s].minimum_compression_size", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'minimum_compression_size' is set, greater than -1 and smaller than 10485760",
		"keyActualValue": "Attribute 'minimum_compression_size' is set but smaller than 0",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_rest_api[name]

	resource.minimum_compression_size > 10485759

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_rest_api[%s].minimum_compression_size", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'minimum_compression_size' is set, greater than -1 and smaller than 10485760",
		"keyActualValue": "Attribute 'minimum_compression_size' is set but greater than 10485759",
	}
}
