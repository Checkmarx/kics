package Cx

CxPolicy [ result ] {

	resourceMetricFilter := input.document[i].Resources
    some name
    resourceMetricFilter[name].Type == "AWS::Logs::MetricFilter"
    
    resourceAlarm := input.document[i].Resources
    some nameAlarm
    resourceAlarm[nameAlarm].Type == "AWS::CloudWatch::Alarm"
   
    checkAlarm(resourceMetricFilter[name].Properties.MetricTransformations[index].MetricNamespace, resourceAlarm[nameAlarm].Properties)

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	     sprintf("Resources.%s.Properties.MetricTransformations.MetricNamespace", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("'Resources.%s.Properties.MetricTransformations[%d].MetricNamespace' should have a valid Namespace in 'AWS::CloudWatch::Alarm')", [name, index]),
                "keyActualValue": 	sprintf("'Resources.%s.FilterPattern.MetricTransformations[%d].MetricNamespace' doesn't have a valid Namespace in 'AWS::CloudWatch::Alarm')", [name, index]),
            }
}
CxPolicy [ result ] {

	resourceMetricFilter := input.document[i].Resources
   
    resourceAlarm := input.document[i].Resources
    some nameAlarm
    resourceAlarm[nameAlarm].Type == "AWS::CloudWatch::Alarm"
   
    resourceSNS := input.document[i].Resources
    some nameSNS
    resourceSNS[nameSNS].Type == "AWS::SNS::Topic"
   
    checkTopic(resourceAlarm[nameAlarm].Properties.AlarmActions[index], nameSNS)

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	     sprintf("Resources.%s.Properties.AlarmActions.Ref", [nameAlarm]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("'Resources.%s.Properties.AlarmActions[%d].Ref' should have a valid resource with 'AWS::SNS::Topic' type)", [nameAlarm, index]),
                "keyActualValue": 	sprintf("'Resources.%s.FilterPattern.AlarmActions[%d].Ref' doesn't have a valid resource with 'AWS::SNS::Topic' type)", [nameAlarm, index]),
            }
}
CxPolicy [ result ] {

	resourceMetricFilter := input.document[i].Resources
    some name
    resourceMetricFilter[name].Type == "AWS::Logs::MetricFilter"
    
    resourceAlarm := input.document[i].Resources
    some nameAlarm
    resourceAlarm[nameAlarm].Type == "AWS::CloudWatch::Alarm"
    
    
	not regex.match("{ *\\(\\$\\.eventName *= *CreateCustomerGateway\\) *\\|\\| *\\(\\$\\.eventName *= *DeleteCustomerGateway\\) *\\|\\| *\\(\\$\\.eventName *= *AttachInternetGateway\\) *\\|\\| *\\(\\$\\.eventName *= *CreateInternetGateway\\) *\\|\\| *\\(\\$\\.eventName *= *DeleteInternetGateway\\) *\\|\\| *\\(\\$\\.eventName *= *DetachInternetGateway\\) *}",
    	resourceMetricFilter[name].Properties.FilterPattern)


    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	     sprintf("Resources.%s.Properties.FilterPattern", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("'Resources.%s.Properties.FilterPattern' should have the right specification')", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.FilterPattern' does not have the right specification", [name])
            }
}
checkAlarm(metricFilter, resourceAlarm) = true {
    resourceAlarm.Namespace != metricFilter
}

checkTopic(resourceAlarm, nameSNS) = true {
    resourceAlarm.Ref != nameSNS
}