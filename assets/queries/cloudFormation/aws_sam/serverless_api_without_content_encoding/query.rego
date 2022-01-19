package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Serverless::Api"
	properties := resource.Properties

	unrecommended_minimum_compression_size(properties.MinimumCompressionSize )

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.MinimumCompressionSize", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Resources.%s.Properties.MinimumCompressionSize is greater than -1 and smaller than 10485760",
		"keyActualValue": "Resources.%s.Properties.MinimumCompressionSize is set but smaller than 0 or greater than 10485759",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "MinimumCompressionSize"], []),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Serverless::Api"
	properties := resource.Properties

	not common_lib.valid_key(properties, "MinimumCompressionSize")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MinimumCompressionSize is defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MinimumCompressionSize is not defined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}


unrecommended_minimum_compression_size(value) {
	value < 0
} else {
	value > 10485759
}
