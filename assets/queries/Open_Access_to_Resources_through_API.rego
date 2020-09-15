package Cx

SupportedResources = "$.resource.aws_api_gateway_method"

CxPolicy [ result ] {
    input.document[i].resource.aws_api_gateway_method[name].authorization = "NONE"
    input.document[i].resource.aws_api_gateway_method[name].http_method != "OPTIONS"

    result := {
                "foundKye": 		[],
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_api_gateway_method", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}
