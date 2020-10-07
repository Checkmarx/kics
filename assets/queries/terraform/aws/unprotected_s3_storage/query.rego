package Cx

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	not resource.server_side_encryption_configuration

    result := mergeWithMetadata({
                "test": resource,
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].server_side_encryption_configuration", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "!null",
                "keyActualValue": 	"null",
                "value":            resource.bucket
              })
}