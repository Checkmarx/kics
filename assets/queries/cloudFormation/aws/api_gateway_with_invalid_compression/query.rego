package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::ApiGateway::RestApi"
	properties := resource.Properties

	res := get_res(properties, name, path)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": res.sk,
		"issueType": res.it,
		"keyExpectedValue": res.kev,
		"keyActualValue": res.kav,
		"searchLine": res.sl,
	}
}

get_res(properties, name, path) = res {
	properties.MinimumCompressionSize < 0
	res := {
		"sk": sprintf("%s%s.Properties.MinimumCompressionSize", [cf_lib.getPath(path), name]),
		"it": "IncorrectValue",
		"kev": sprintf("Resources.%s.Properties.MinimumCompressionSize should be greater than -1 and smaller than 10485760", [name]),
		"kav": sprintf("Resources.%s.Properties.MinimumCompressionSize is set to smaller than 0", [name]),
		"sl": common_lib.build_search_line(path, [name, "Properties", "MinimumCompressionSize"]),
	}
} else = res {
	properties.MinimumCompressionSize > 10485759
	res := {
		"sk": sprintf("%s%s.Properties.MinimumCompressionSize", [cf_lib.getPath(path), name]),
		"it": "IncorrectValue",
		"kev": sprintf("Resources.%s.Properties.MinimumCompressionSize should be greater than -1 and smaller than 10485760", [name]),
		"kav": sprintf("Resources.%s.Properties.MinimumCompressionSize is set to greater than 10485759", [name]),
		"sl": common_lib.build_search_line(path, [name, "Properties", "MinimumCompressionSize"]),
	}
} else = res {
	not common_lib.valid_key(properties, "MinimumCompressionSize")
	res := {
		"sk": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"it": "MissingAttribute",
		"kev": sprintf("Resources.%s.Properties.MinimumCompressionSize should be defined", [name]),
		"kav": sprintf("Resources.%s.Properties.MinimumCompressionSize is not defined", [name]),
		"sl": common_lib.build_search_line(path, [name, "Properties"]),
	}
}