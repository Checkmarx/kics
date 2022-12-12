package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SageMaker::NotebookInstance"
	not common_lib.valid_key(resource.Properties, "KmsKeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KmsKeyId' should be defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KmsKeyId' is not defined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SageMaker::NotebookInstance"
	is_string(resource.Properties.KmsKeyId)
	resource.Properties.KmsKeyId == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.KmsKeyId", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KmsKeyId' should not be empty", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KmsKeyId' is empty", [name]),
	}
}
