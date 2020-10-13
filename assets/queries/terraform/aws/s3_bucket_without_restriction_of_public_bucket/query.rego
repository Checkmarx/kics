package Cx

#default of restrict_public_buckets is false
CxPolicy [ result ] {
    pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
    object.get(pubACL, "restrict_public_buckets", "not found") == "not found"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket_public_access_block[%s].restrict_public_buckets", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "true",
                "keyActualValue": 	"null"
              })
}

CxPolicy [ result ] {
    pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
    pubACL.restrict_public_buckets == false

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket_public_access_block[%s].restrict_public_buckets", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "true",
                "keyActualValue": 	"false"
              })
}
