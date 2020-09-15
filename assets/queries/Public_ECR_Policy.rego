package Cx

SupportedResources = "$.resource.aws_ecr_repository_policy"

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_ecr_repository_policy[name].policy
    re_match("\"Principal\"\\s*:\\s*\"*\"", pol)

    result := {
                "foundKye": 		pol,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_ecr_repository_policy", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}
