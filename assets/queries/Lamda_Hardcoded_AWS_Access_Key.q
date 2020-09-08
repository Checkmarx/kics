package Cx

#CxPragma "$.resource.aws_lambda_function"

result [ getMetadata({"id" : input.All[i].CxId, "data" : [vars], "search": "variables"}) ] {
	some i    
    vars = input.All[i].resource.aws_lambda_function[name].environment.variables
    re_match("[A-Za-z0-9/+=]{40}", vars[_])
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [vars], "search": "variables"}) ] {
	some i    
    vars = input.All[i].resource.aws_lambda_function[name].environment.variables
    re_match("[A-Z0-9]{20}", vars[_])
}

has_field(obj, field) {
    obj[field]
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Lambda hardcoded AWS access key",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
