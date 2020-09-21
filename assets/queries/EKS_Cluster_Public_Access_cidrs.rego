package Cx

SupportedResources = "$.resource.aws_eks_cluster"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_eks_cluster[name]
    resource.vpc_config.endpoint_public_access = true
    resource.vpc_config.public_access_cidrs[_] = "0.0.0.0/0"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_eks_cluster[%s].vpc_config.public_access_cidrs", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": null,
                "keyActualValue": 	"0.0.0.0/0"
              })
}

#default vaule of cidrs is "0.0.0.0/0"
CxPolicy [ result ] {
    resource := input.document[i].resource.aws_eks_cluster[name]
    resource.vpc_config.endpoint_public_access = true
    not resource.vpc_config.public_access_cidrs

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_eks_cluster[%s].vpc_config.public_access_cidrs", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": null,
                "keyActualValue": 	null
              })
}



