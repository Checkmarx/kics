package Cx

#CxPragma "$.resource.aws_api_gateway_method"

result [ getMetadata({"id" : input.All[i].CxId, "data" : [], "search": "http_method"}) ] {
	some i
    input.All[i].resource.aws_api_gateway_method[_].authorization = "NONE"
    input.All[i].resource.aws_api_gateway_method[_].http_method != "OPTIONS"
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Open access to resources through API",
        "severity": "Medium",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
