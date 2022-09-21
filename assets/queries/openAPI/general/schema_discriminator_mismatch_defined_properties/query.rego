package Cx

import data.generic.openapi as openapi_lib

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	[path, value] = walk(doc)
	schema := value.schema
	discriminator := openapi_lib.get_discriminator(schema, version)
	not match(schema, discriminator.obj)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.%s", [openapi_lib.concat_path(path), discriminator.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.{{%s}}.%s should be set in 'properties'", [openapi_lib.concat_path(path), discriminator.path]),
		"keyActualValue": sprintf("%s.{{%s}}.%s is not set in 'properties'", [openapi_lib.concat_path(path), discriminator.path]),
		"overrideKey": version,
	}
}

CxPolicy[result] {
	doc := input.document[i]
	version := openapi_lib.check_openapi(doc)
	version != "undefined"

	schemaInfo := openapi_lib.get_schema_info(doc, version)

	schema := schemaInfo.obj[s]
	discriminator := openapi_lib.get_discriminator(schema, version)
	not match(schema, discriminator.obj)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.{{%s}}.%s", [schemaInfo.path, s, discriminator.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.{{%s}}.%s should be set in 'properties'", [schemaInfo.path, s, discriminator.path]),
		"keyActualValue": sprintf("%s.{{%s}}.%s is not set in 'properties'", [schemaInfo.path, s, discriminator.path]),
		"overrideKey": version,
	}
}

match(schema, discriminator) {
	schema.properties[discriminator]
}
