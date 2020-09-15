package Cx

SupportedResources = "$.resource.aws_iam_policy_attachment"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_iam_policy_attachment[name]
    resource.user

    result := {
                "foundKye": 		resource,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_iam_policy_attachment", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}
