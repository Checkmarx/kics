package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::SageMaker::NotebookInstance"

	not common_lib.valid_key(resource.Properties, "SubnetId")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SubnetId", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SubnetId is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.SubnetId is not defined", [name]),
	}
}
