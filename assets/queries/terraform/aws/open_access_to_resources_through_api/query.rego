package Cx

CxPolicy [ result ] {
    resource = input.file[i].resource.aws_api_gateway_method[name]
    resource.authorization = "NONE"
    resource.http_method != "OPTIONS"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_api_gateway_method[%s].authorization", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'authorization' is not equal 'NONE'",
                "keyActualValue": 	"'authorization' is equal 'NONE'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
