package Cx

CxPolicy [ result ] {
    resource = input.document[i].resource.aws_api_gateway_method[name]
    resource.authorization = "NONE"
    resource.http_method != "OPTIONS"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_api_gateway_method[%s].authorization", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT NONE",
                "keyActualValue": 	"NONE"
              })
}
