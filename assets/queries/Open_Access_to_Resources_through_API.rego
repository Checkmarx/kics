package Cx

SupportedResources = "$.resource.aws_api_gateway_method"

CxPolicy [ result ] {
    resource = input.document[i].resource.aws_api_gateway_method[name]

    resource.authorization = "NONE"
    resource.http_method != "OPTIONS"

    result := {
                "foundKye": 		resource,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_api_gateway_method", name]),
                "issueType":		"IncorrectValue",
                "keyName":			"authorization",
                "keyExpectedValue": null,
                "keyActualValue": 	"NONE",
                #{metadata}
              }
}
