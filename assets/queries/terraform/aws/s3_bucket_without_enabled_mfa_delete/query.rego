package Cx

#default of mfa_delete is false
CxPolicy [ result ] {
    ver := input.file[i].resource.aws_s3_bucket[name].versioning
    object.get(ver, "mfa_delete", "not found") == "not found"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].versioning.mfa_delete", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'mfa_delete' is equal 'true'",
                "keyActualValue": 	"'mfa_delete' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

CxPolicy [ result ] {
    ver := input.file[i].resource.aws_s3_bucket[name].versioning
    ver.mfa_delete != true

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].versioning.mfa_delete", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'mfa_delete' is equal 'true'",
                "keyActualValue": 	"'mfa_delete' is equal 'false'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
