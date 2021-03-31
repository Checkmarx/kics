package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::SageMaker::NotebookInstance"

	object.get(resource.Properties, "SubnetId", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SubnetId", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SubnetId is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.SubnetId is not defined", [name]),
	}
}
