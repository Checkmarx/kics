package Cx

#CxPragma "$.resource.aws_instance"

#Hard-coded AWS access key / secret key exists in EC2 user data
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

result [ getMetadata({"id" : input.All[i].CxId, "data" : [ud], "search": ["resource", "user_data"]}) ] {
	ud := input.All[i].resource.aws_instance[name].user_data
    re_match("([^A-Z0-9])[A-Z0-9]{20}([^A-Z0-9])", ud)
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [ud], "search": ["resource", "user_data"]}) ] {
	ud := input.All[i].resource.aws_instance[name].user_data
    re_match("[A-Za-z0-9/+=]{40}([^A-Za-z0-9/+=])", ud)
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Hardcoded AWS access key",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}

