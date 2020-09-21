package Cx

SupportedResources = "$.resource.aws_ecr_repository_policy"

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_ecr_repository_policy[name].policy
    re_match("\"Principal\"\\s*:\\s*\"*\"", pol)

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_ecr_repository_policy[%s].policy", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT *",
                "keyActualValue": 	"*"
              })
}
