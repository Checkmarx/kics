package Cx

SupportedResources = "$.resource.aws_eks_cluster"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_eks_cluster[name]
    resource.vpc_config.endpoint_public_access = true

    result := {
                "foundKye": 		resource.vpc_config,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["resource", "aws_eks_cluster", name]), "endpoint_public_access"],
                "issueType":		"IncorrectValue",
                "keyName":			"vpc_config.endpoint_public_access",
                "keyExpectedValue": false,
                "keyActualValue": 	true,
                #{metadata}
              }
}
