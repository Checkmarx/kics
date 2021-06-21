package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	openapi_lib.check_openapi(doc) == "2.0"

	[path, value] := walk(doc)

	field := path[0]
	all([field != "id", field != "file"])
	not known_swagger_object_field(field)

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
	openapi_lib.check_openapi(doc) == "2.0"

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
	openapi_lib.check_openapi(doc) == "2.0"

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
	openapi_lib.check_openapi(doc) == "2.0"

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

swagger := {
	"swagger",
	"info",
	"host",
	"basePath",
	"schemes",
	"consumes",
	"produces",
	"paths",
	"definitions",
	"parameters",
	"responses",
	"securityDefinitions",
	"security",
	"tags",
	"externalDocs",
}

known_swagger_object_field(field) {
	field == swagger[_]
}

known_field(object, value) {
	object[_] == value
}

parameters_properties := {
	"$ref",
	"name",
	"in",
	"description",
	"required",
	"schema",
	"type",
	"format",
	"allowEmptyValue",
	"items",
	"collectionFormat",
	"default",
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
	"enum",
	"multipleOf",
}

schema_properties := {
	"$ref",
	"format",
	"title",
	"description",
	"default",
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
	"items",
	"allOf",
	"properties",
	"additionalProperties",
	"descriminator",
	"readOnly",
	"xml",
	"externalDocs",
	"example",
}

array_objects := {
	"tags": {
		"name",
		"description",
		"externalDocs",
	},
	"parameters": parameters_properties,
}

map_objects := {
	"definitions": schema_properties,
	"headers": {
		"$ref",
		"description",
		"type",
		"format",
		"items",
		"collectionFormat",
		"default",
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
		"enum",
		"multipleOf",
	},
	"parameters": parameters_properties,
	"responses": {
		"$ref",
		"description",
		"schema",
		"headers",
		"examples",
	},
	"paths": {
		"$ref",
		"get",
		"put",
		"post",
		"delete",
		"options",
		"head",
		"patch",
		"parameters",
	},
	"securityDefinitions": {
		"type",
		"description",
		"name",
		"in",
		"flow",
		"authorizationUrl",
		"tokenUrl",
		"scopes",
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
	"operation": {
		"tags",
		"summary",
		"description",
		"externalDocs",
		"operationId",
		"consumes",
		"produces",
		"parameters",
		"responses",
		"schemes",
		"deprecated",
		"security",
	},
	"externalDocs": {
		"description",
		"url",
	},
	"items": {
		"$ref",
		"type",
		"format",
		"items",
		"collectionFormat",
		"default",
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
		"enum",
		"multipleOf",
	},
	"xml": {
		"name",
		"namespace",
		"prefix",
		"attribute",
		"wrapped",
	},
	"schema": schema_properties,
}
