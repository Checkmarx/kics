package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SageMaker::NotebookInstance"
	object.get(resource.Properties, "KmsKeyId", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KmsKeyId' is defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KmsKeyId' is not defined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SageMaker::NotebookInstance"
	resource.Properties.KmsKeyId == null

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.KmsKeyId", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KmsKeyId' is not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KmsKeyId' is null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SageMaker::NotebookInstance"
	is_string(resource.Properties.KmsKeyId)
	resource.Properties.KmsKeyId == ""

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.KmsKeyId", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KmsKeyId' is not empty", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KmsKeyId' is empty", [name]),
	}
}
