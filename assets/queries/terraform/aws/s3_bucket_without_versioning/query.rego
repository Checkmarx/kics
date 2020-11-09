package Cx

#default of mfa_delete is false
CxPolicy [ result ] {
	b := input.file[i].resource.aws_s3_bucket[name]
	not b.versioning

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'versioning' is equal 'true'",
                "keyActualValue": 	"'versioning' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

#default of enabled is false
CxPolicy [ result ] {
	b := input.file[i].resource.aws_s3_bucket[name]
	object.get(b.versioning, "enabled", "not found") == "not found"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].versioning", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'versioning' is equal 'true'",
                "keyActualValue": 	"'versioning' is missing",
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
	v := input.file[i].resource.aws_s3_bucket[name].versioning
    v.enabled != true

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].versioning.enabled", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'versioning' is equal 'true'",
                "keyActualValue": 	"'versioning' is equal 'false'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
