package Cx

SupportedResources = "$.resource.aws_iam_policy_attachment"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_iam_policy_attachment[name]
    resource.user

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_policy_attachment[%s].user", [name]),
                "issueType":		"RedundantAttribute",
                "keyExpectedValue": null,
                "keyActualValue": 	resource.user
              })
}
