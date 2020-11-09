package Cx

CxPolicy [ result ] {
    pubACL := input.file[i].resource.aws_s3_bucket_public_access_block[name]
    pubACL.ignore_public_acls == true

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket_public_access_block[%s].ignore_public_acls", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'ignore_public_acls' is equal 'false'",
                "keyActualValue": 	"'ignore_public_acls' is equal 'true'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
