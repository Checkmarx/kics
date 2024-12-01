package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.spec.metrics[index]
	document.kind == "HorizontalPodAutoscaler"

	resource.type == "Object"
	not checkIsValidObject(resource)

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"searchKey": "spec.metrics",
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.metrics[%d] is a valid object ", [index]),
		"keyActualValue": sprintf("spec.metrics[%d] is an invalid object ", [index]),
	}
}

checkIsValidObject(resource) {
	resource.object != null
	resource.object.metric != null
	resource.object.target != null
	resource.object.describedObject.name != null
	resource.object.describedObject.apiVersion != null
	resource.object.describedObject.kind != null
}
