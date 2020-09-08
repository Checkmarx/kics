package Cx

#CxPragma "$.resource.aws_cloudwatch_log_group"

#Cloudwatch log groups without retention days specified
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group

result [ getMetadata({"id" : input.All[i].CxId, "data" : [ res ], "search": "\"aws_cloudwatch_log_group\""}) ] {
	res := input.All[i].resource.aws_cloudwatch_log_group[name]
    not res.retention_in_days
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Cloudwatch without retention days",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}


