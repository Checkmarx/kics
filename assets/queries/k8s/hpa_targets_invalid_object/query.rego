package Cx

CxPolicy[result] {
	resource := input.document[i].spec.metrics[index]
	input.document[i].kind == "HorizontalPodAutoscaler"

	resource.type == "Object"
	not checkIsValidObject(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": input.document[i].kind,
		"resourceName": input.document[i].metadata.name,
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
