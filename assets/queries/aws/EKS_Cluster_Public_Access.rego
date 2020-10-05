package Cx

SupportedResources = "$.resource.aws_eks_cluster"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_eks_cluster[name]
    resource.vpc_config.endpoint_public_access = true

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_eks_cluster[%s].vpc_config.endpoint_public_access", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "false",
                "keyActualValue": 	"true"
              })
}
