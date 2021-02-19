package Cx

CxPolicy[result] {
	resourceMetricFilter := input.document[i].Resources
	some name
	resourceMetricFilter[name].Type == "AWS::Logs::MetricFilter"

	resourceAlarm := input.document[i].Resources
	some nameAlarm
	resourceAlarm[nameAlarm].Type == "AWS::CloudWatch::Alarm"

	resourceMetricFilter[name].Properties.MetricTransformations[index].MetricNamespace != resourceAlarm[nameAlarm].Properties.Namespace

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.MetricTransformations", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.MetricTransformations[%d].MetricNamespace' should have a valid Namespace in 'AWS::CloudWatch::Alarm'", [name, index]),
		"keyActualValue": sprintf("'Resources.%s.Properties.MetricTransformations[%d].MetricNamespace' doesn't have a valid Namespace in 'AWS::CloudWatch::Alarm'", [name, index]),
	}
}

CxPolicy[result] {
	resourceMetricFilter := input.document[i].Resources

	resourceAlarm := input.document[i].Resources
	some nameAlarm
	resourceAlarm[nameAlarm].Type == "AWS::CloudWatch::Alarm"

	object.get(resourceAlarm[nameAlarm].Properties, "AlarmActions", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [nameAlarm]),
		"issueType": "MissingValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AlarmActions' should be defined", [nameAlarm]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AlarmActions' is not defined", [nameAlarm]),
	}
}

CxPolicy[result] {
	resourceMetricFilter := input.document[i].Resources

	resourceAlarm := input.document[i].Resources
	some nameAlarm
	resourceAlarm[nameAlarm].Type == "AWS::CloudWatch::Alarm"

	count(resourceAlarm[nameAlarm].Properties.AlarmActions) == 0
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AlarmActions", [nameAlarm]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AlarmActions' should have a valid resource with 'AWS::SNS::Topic' type", [nameAlarm]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AlarmActions' doesn't have a valid resource with 'AWS::SNS::Topic' type", [nameAlarm]),
	}
}

CxPolicy[result] {
	resourceMetricFilter := input.document[i].Resources
	some name
	resourceMetricFilter[name].Type == "AWS::Logs::MetricFilter"

	resourceAlarm := input.document[i].Resources
	some nameAlarm
	resourceAlarm[nameAlarm].Type == "AWS::CloudWatch::Alarm"

	not regex.match("{ *\\(\\$\\.eventName *= *\"?ConsoleLogin\"?\\) *\\&\\& *\\(\\$\\.additionalEventData\\.MFAUsed *!= *\"?Yes\"?\\) *}|{ *\\$\\.userIdentity\\.sessionContext\\.attributes\\.mfaAuthenticated *!= *true *}", resourceMetricFilter[name].Properties.FilterPattern)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.FilterPattern", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.FilterPattern' should have the right specification')", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.FilterPattern' does not have the right specification", [name]),
	}
}
