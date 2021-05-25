package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	field := path[0]
	all([field != "id", field != "file"])
	not known_openapi_object_field(field)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s", [field]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The field '%s' is known in the openapi object", [field]),
		"keyActualValue": sprintf("The field '%s' is unknown in the openapi object", [field]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	object := simple_objects[o]
	path[minus(count(path), 1)] == o

	v := value[x]
	not known_field(object, x)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The field '%s' is known in the %s object", [x, o]),
		"keyActualValue": sprintf("The field '%s' is unknown in the %s object", [x, o]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	object := array_objects[o]
	path[minus(count(path), 1)] == o
	is_array(value)

	field := value[x][v]
	not known_field(object, v)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), v]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The field '%s' is known in the %s object", [v, o]),
		"keyActualValue": sprintf("The field '%s' is unknown in the %s object", [v, o]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	object := map_objects[o]
	path[minus(count(path), 2)] == o

	v := value[x]
	not known_field(object, x)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The field '%s' is known in the %s object", [x, o]),
		"keyActualValue": sprintf("The field '%s' is unknown in the %s object", [x, o]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) != "undefined"

	[path, value] := walk(doc)

	path[minus(count(path), 3)] == "callbacks"

	v := value[x]
	not known_field(map_objects.paths, x)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The field '%s' is known in the callbacks object", [x]),
		"keyActualValue": sprintf("The field '%s' is unknown in the callbacks object", [x]),
	}
}

openapi := {
	"openapi",
	"info",
	"paths",
	"servers",
	"components",
	"security",
	"tags",
	"externalDocs",
}

known_openapi_object_field(field) {
	field == openapi[_]
}

known_field(object, value) {
	object[_] == value
}

flow := {
	"authorizationUrl",
	"tokenUrl",
	"refreshUrl",
	"scopes",
}

parameters_properties := {
	"$ref",
	"name",
	"in",
	"description",
	"required",
	"deprecated",
	"allowEmptyValue",
	"style",
	"explode",
	"allowReserved",
	"schema",
	"example",
	"examples",
	"content",
}

request_body_properties := {
	"$ref",
	"description",
	"content",
	"required",
}

schema_properties := {
	"$ref",
	"title",
	"multipleOf",
	"maximum",
	"exclusiveMaximum",
	"minimum",
	"exclusiveMinimum",
	"maxLength",
	"minLength",
	"pattern",
	"maxItems",
	"minItems",
	"uniqueItems",
	"maxProperties",
	"minProperties",
	"required",
	"enum",
	"type",
	"allOf",
	"oneOf",
	"not",
	"items",
	"properties",
	"description",
	"format",
	"default",
	"nullable",
	"discriminator",
	"readOnly",
	"writeOnly",
	"xml",
	"externalDocs",
	"example",
	"deprecated",
}

array_objects := {
	"tags": {
		"name",
		"description",
		"externalDocs",
	},
	"servers": {
		"url",
		"description",
		"variables",
	},
	"parameters": parameters_properties,
}

map_objects := {
	"encoding": {
		"contentType",
		"headers",
		"style",
		"explode",
		"allowReserved",
	},
	"variables": {
		"enum",
		"default",
		"description",
	},
	"schemas": schema_properties,
	"links": {
		"$ref",
		"operationRef",
		"operationId",
		"parameters",
		"requestBody",
		"description",
		"server",
	},
	"headers": {
		"$ref",
		"description",
		"required",
		"deprecated",
		"allowEmptyValue",
		"style",
		"explode",
		"allowReserved",
		"schema",
		"example",
		"examples",
		"content",
	},
	"securitySchemes": {
		"$ref",
		"type",
		"description",
		"name",
		"in",
		"scheme",
		"bearerFormat",
		"flows",
		"openIdConnectUrl",
	},
	"requestBodies": request_body_properties,
	"parameters": parameters_properties,
	"examples": {
		"$ref",
		"summary",
		"description",
		"value",
		"externalValue",
	},
	"responses": {
		"$ref",
		"description",
		"headers",
		"content",
		"links",
	},
	"content": {
		"schema",
		"example",
		"examples",
		"encoding",
	},
	"paths": {
		"$ref",
		"sumarry",
		"description",
		"get",
		"post",
		"put",
		"delete",
		"options",
		"head",
		"patch",
		"trace",
		"servers",
		"parameters",
	},
}

simple_objects := {
	"info": {
		"title",
		"description",
		"termsOfService",
		"contact",
		"license",
		"version",
	},
	"contact": {
		"name",
		"url",
		"email",
	},
	"license": {
		"name",
		"url",
	},
	"components": {
		"schemas",
		"responses",
		"parameters",
		"examples",
		"requestBodies",
		"headers",
		"securitySchemes",
		"links",
		"callbacks",
	},
	"operation": {
		"tags",
		"summary",
		"description",
		"externalDocs",
		"operationId",
		"parameters",
		"requestBody",
		"responses",
		"callbacks",
		"deprecated",
		"security",
		"servers",
	},
	"externalDocs": {
		"description",
		"url",
	},
	"requestBody": request_body_properties,
	"discriminator": {
		"propertyName",
		"mapping",
	},
	"xml": {
		"name",
		"namespace",
		"prefix",
		"attribute",
		"wrapped",
	},
	"flows": {
		"implicit",
		"password",
		"clientCredentials",
		"authorizationCode",
	},
	"implicit": flow,
	"password": flow,
	"clientCredentials": flow,
	"authorizationCode": flow,
	"schema": schema_properties,
}
