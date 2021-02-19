package Cx

CxPolicy[result] {
	resource := input.document[i].spec.metrics[index]

	resourceKind := input.document[i].kind

	IsHPA(resourceKind)
	not checkIsValidObject(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": "spec.metrics",
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.metrics[%d] is a valid object ", [index]),
		"keyActualValue": sprintf("spec.metrics[%d] is an invalid object ", [index]),
	}
}

IsHPA(resourceKind) {
	resourceKind == "HorizontalPodAutoscaler"
}

checkIsValidObject(resource) {
	resource.type == "Object"
	resource.object != null
	resource.object.metric != null
	resource.object.target != null
	resource.object.describedObject.name != null
	resource.object.describedObject.apiVersion != null
	resource.object.describedObject.kind != null
}
