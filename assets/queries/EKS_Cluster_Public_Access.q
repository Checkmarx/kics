package Cx


#CxPragma "$.resource.aws_eks_cluster"

#Amazon EKS public endpoint is enables
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster

result [ getMetadata({"id" : input.All[i].CxId, "data" : [ input.All[i].resource.aws_eks_cluster[_].vpc_config], "search": ["aws_eks_cluster", "endpoint_public_access"]}) ] {
	input.All[i].resource.aws_eks_cluster[name].vpc_config.endpoint_public_access = true
}



getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "EKS cluster public access",
        "severity": "Medium",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}


