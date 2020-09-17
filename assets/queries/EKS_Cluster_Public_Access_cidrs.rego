package Cx

SupportedResources = "$.resource.aws_eks_cluster"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_eks_cluster[name]
    resource.vpc_config.endpoint_public_access = true
    resource.vpc_config.public_access_cidrs[_] = "0.0.0.0/0"

    result := {
                "foundKye": 		resource.vpc_config,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_eks_cluster", name]), "public_access_cidrs"],
                "issueType":		"IncorrectValue",
                "keyName":			"vpc_config.public_access_cidrs",
                "keyExpectedValue": null,
                "keyActualValue": 	"0.0.0.0/0",
                #{metadata}
              }
}

#default vaule of cidrs is "0.0.0.0/0"
CxPolicy [ result ] {
    resource := input.document[i].resource.aws_eks_cluster[name]
    resource.vpc_config.endpoint_public_access = true
    not resource.vpc_config.public_access_cidrs

    result := {
                "foundKye": 		resource.vpc_config,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_eks_cluster", name]), "vpc_config"],
                "issueType":		"MissingAttribute",
                "keyName":			"vpc_config.public_access_cidrs",
                "keyExpectedValue": null,
                "keyActualValue": 	null,
                #{metadata}
              }
}



