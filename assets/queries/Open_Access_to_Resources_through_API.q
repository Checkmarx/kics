package Cx

#CxPragma "$.resource.aws_api_gateway_method"

#Open access to back-end resources through API
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method

result [ getMetadata({"id" : input.All[i].CxId, "data" : [], "search": "http_method"}) ] {
	input.All[i].resource.aws_api_gateway_method[name].authorization = "NONE"
    input.All[i].resource.aws_api_gateway_method[name].http_method != "OPTIONS"
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Open access to resources through API",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}

