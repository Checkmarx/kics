package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::Instance"

	not common_lib.valid_key(resource.Properties, "EbsOptimized")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EbsOptimized", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties to have EbsOptimized set to true.", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties doesn't have EbsOptimized set to true.", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::Instance"

	resource.Properties["EbsOptimized"] == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EbsOptimized", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties to have EbsOptimized set to true.", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EbsOptimized is set to false.", [name]),
	}
}
