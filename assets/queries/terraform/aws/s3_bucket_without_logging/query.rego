package Cx

CxPolicy [ result ] {
    s3 := input.file[i].resource.aws_s3_bucket[name]
	not s3.logging

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].logging", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'logging' exists",
                "keyActualValue": 	"'logging' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
