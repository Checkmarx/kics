package Cx


CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"

    isMissing(resource.Properties,"SnsTopicName")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SnsTopicName' is set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SnsTopicName' is undefined", [name]),
	}
}

isMissing(properties,attribute) {
    object.get(properties, attribute, "undefined") == "undefined"
}

isMissing(properties,attribute) {
    attr := object.get(properties, attribute, "undefined")
    attr != "undefined"
    attr == ""
}
