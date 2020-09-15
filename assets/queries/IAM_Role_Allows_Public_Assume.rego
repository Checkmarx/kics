package Cx

SupportedResources = "$.resource.aws_iam_role"

CxPolicy [ result ] {
	policy := input.document[i].resource.aws_iam_role[name].assume_role_policy
    re_match("Service", policy)
    out := json.unmarshal(policy)
    not out.Statement[ix].Effect
    aws := out.Statement[ix].Principal.AWS
    contains(aws, "*")

    result := {
                "foundKye": 		out,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_iam_role", name]), "assume_role_policy", "Principal", "*"],
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}

CxPolicy [ result ] {
	policy := input.document[i].resource.aws_iam_role[name].assume_role_policy
    re_match("Service", policy)
    out := json.unmarshal(policy)
    out.Statement[ix].Effect != "Deny"
    aws := out.Statement[ix].Principal.AWS
    contains(aws, "*")

    result := {
                "foundKye": 		out,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_iam_role", name]), "assume_role_policy", "Principal", "*"],
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}

