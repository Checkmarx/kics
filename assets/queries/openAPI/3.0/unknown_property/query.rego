package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

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
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	objectValues := {"array": array_objects, "simple": simple_objects, "map": map_objects}
	objValues := objectValues[objType][object]

	index := {"array": 1, "simple": 1, "map": 2}
	path[minus(count(path), index[objType])] == object

	objType == "array"
	is_array(value)
	value[x][field]
	not known_field(objValues, field)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), field]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The field '%s' is known in the %s object", [field, object]),
		"keyActualValue": sprintf("The field '%s' is unknown in the %s object", [field, object]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	objectValues := {"array": array_objects, "simple": simple_objects, "map": map_objects}
	objValues := objectValues[objType][object]

	index := {"array": 1, "simple": 1, "map": 2}
	path[minus(count(path), index[objType])] == object

	any([objType == "simple", objType == "map"])
	value[field]
	not known_field(objValues, field)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), field]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The field '%s' is known in the %s object", [field, object]),
		"keyActualValue": sprintf("The field '%s' is unknown in the %s object", [field, object]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "3.0"

	[path, value] := walk(doc)

	path[minus(count(path), 3)] == "callbacks"

	value[x]
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
	"RefMetadata",
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
	"RefMetadata",
	"description",
	"content",
	"required",
}

schema_properties := {
	"$ref",
	"RefMetadata",
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
	"headers": {
		"$ref",
		"RefMetadata",
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
		"RefMetadata",
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
		"RefMetadata",
		"summary",
		"description",
		"value",
		"externalValue",
	},
	"responses": {
		"$ref",
		"RefMetadata",
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
