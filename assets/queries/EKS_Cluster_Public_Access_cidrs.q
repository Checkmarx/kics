package Cx


#CxPragma "$.resource.aws_eks_cluster"

#Amazon EKS public endpoint is enables and accessible to all: 0.0.0.0/0"
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster

result [ getMetadata({"id" : input.All[i].CxId, "data" : [ input.All[i].resource.aws_eks_cluster[_].vpc_config], "search": ["aws_eks_cluster", "public_access_cidrs"]}) ] {
	input.All[i].resource.aws_eks_cluster[name].vpc_config.endpoint_public_access = true
    input.All[i].resource.aws_eks_cluster[name].vpc_config.public_access_cidrs[_] = "0.0.0.0/0"
}

#default vaule of cidrs is "0.0.0.0/0"
result [ getMetadata({"id" : input.All[i].CxId, "data" : [ input.All[i].resource.aws_eks_cluster[_].vpc_config], "search": ["aws_eks_cluster", "public_access_cidrs"]}) ] {
	input.All[i].resource.aws_eks_cluster[name].vpc_config.endpoint_public_access = true
    not input.All[i].resource.aws_eks_cluster[name].vpc_config.public_access_cidrs
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "EKS cluster public access cidrs",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}


