package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Serverless::Api"
	properties := resource.Properties

	res := get_res(properties, name)

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

get_res(properties, name) = res {
	unrecommended_minimum_compression_size(properties.MinimumCompressionSize)
	res := {
		"sk": sprintf("Resources.%s.Properties.MinimumCompressionSize", [name]),
		"it": "IncorrectValue",
		"kev": sprintf("Resources.%s.Properties.MinimumCompressionSize should be greater than -1 and smaller than 10485760", [name]),
		"kav": sprintf("Resources.%s.Properties.MinimumCompressionSize is set but smaller than 0 or greater than 10485759", [name]),
		"sl": common_lib.build_search_line(["Resources", name, "Properties", "MinimumCompressionSize"], []),
	}
} else = res {
	not common_lib.valid_key(properties, "MinimumCompressionSize")
	res := {
		"sk": sprintf("Resources.%s.Properties", [name]),
		"it": "MissingAttribute",
		"kev": sprintf("Resources.%s.Properties.MinimumCompressionSize should be defined and not null", [name]),
		"kav": sprintf("Resources.%s.Properties.MinimumCompressionSize is not defined or null", [name]),
		"sl": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

unrecommended_minimum_compression_size(value) {
	value < 0
} else {
	value > 10485759
}