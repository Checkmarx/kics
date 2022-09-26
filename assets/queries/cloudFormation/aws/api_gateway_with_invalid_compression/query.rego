package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	properties := resource.Properties

	properties.MinimumCompressionSize < 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.MinimumCompressionSize", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Resources.%s.Properties.MinimumCompressionSize should be greater than -1 and smaller than 10485760",
		"keyActualValue": "Resources.%s.Properties.MinimumCompressionSize is set to smaller than 0",
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "MinimumCompressionSize"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	properties := resource.Properties

	properties.MinimumCompressionSize > 10485759

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.MinimumCompressionSize", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Resources.%s.Properties.MinimumCompressionSize should be greater than -1 and smaller than 10485760",
		"keyActualValue": "Resources.%s.Properties.MinimumCompressionSize is set to greater than 10485759",
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "MinimumCompressionSize"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	properties := resource.Properties

	not common_lib.valid_key(properties, "MinimumCompressionSize")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MinimumCompressionSize should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MinimumCompressionSize is not defined", [name]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties"]),
	}
}
