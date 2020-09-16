package Cx

SupportedResources = "$.resource.aws_iam_role"

CxPolicy [ result ] {
	policy := input.document[i].resource.aws_iam_role[name].assume_role_policy
    re_match("arn:aws:iam::", policy)
    out := json.unmarshal(policy)
    aws := out.Statement[idx].Principal.AWS
    contains(aws, "arn:aws:iam::")
    contains(aws, ":root")

    result := {
                "foundKye": 		aws,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_iam_role", name]),
                "issueType":		"IncorrectValue",
                "keyName":			"assume_role_policy",
                "keyExpectedValue": null,
                "keyActualValue": 	null,
                #{metadata}
              }
}
