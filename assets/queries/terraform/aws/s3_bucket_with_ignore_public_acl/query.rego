package Cx

CxPolicy [ result ] {
    pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
    pubACL.ignore_public_acls == true

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket_public_access_block[%s].ignore_public_acls", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'ignore_public_acls' is equal 'false'",
                "keyActualValue": 	"'ignore_public_acls' is equal 'true'"
              })
}
