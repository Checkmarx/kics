package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::SageMaker::NotebookInstance"

	not common_lib.valid_key(resource.Properties, "SubnetId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SubnetId", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SubnetId should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.SubnetId is not defined", [name]),
	}
}
