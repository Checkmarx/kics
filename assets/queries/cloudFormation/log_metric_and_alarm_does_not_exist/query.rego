package Cx

CxPolicy [ result ] {

  allEvents = ["($.eventName=DeleteGroupPolicy)","($.eventName=DeleteRolePolicy)", "($.eventName=DeleteUserPolicy)", "($.eventName=PutGroupPolicy)", "($.eventName=PutRolePolicy)", "($.eventName=PutUserPolicy)", "($.eventName=CreatePolicy)", "($.eventName=DeletePolicy)", "($.eventName=CreatePolicyVersion)", "($.eventName=DeletePolicyVersion)", "($.eventName=AttachRolePolicy)", "($.eventName=DetachRolePolicy)","($.eventName=AttachUserPolicy)","($.eventName=DetachUserPolicy)","($.eventName=AttachGroupPolicy)","($.eventName=DetachGroupPolicy)"]

	resourceMetricFilter := input.document[i].Resources
    some name
    resourceMetricFilter[name].Type == "AWS::Logs::MetricFilter"
    
    resourceAlarm := input.document[i].Resources
    some nameAlarm
    resourceAlarm[nameAlarm].Type == "AWS::CloudWatch::Alarm"
    
    checkAlarm(resourceMetricFilter[name].Properties, resourceAlarm[nameAlarm].Properties)
    
    removeInitialBrack := replace(resourceMetricFilter[name].Properties.FilterPattern, "{", "")
    removeLastBrack := replace(removeInitialBrack, "}", "")
    filterPatternSplitted := split(removeLastBrack, "||")

    not contains(filterPatternSplitted, allEvents) 

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	     sprintf("Resources.%s.Properties.FilterPattern", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("'Resources.%s.Properties.FilterPattern' should have the right specification, i.g('($.eventName=DeleteGroupPolicy)')", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.FilterPattern' does not have the right specification", [name])
            }
}

checkAlarm(metricFilter, resourceAlarm) = true {
    resourceAlarm.Namespace != metricFilter.MetricTransformations[_].MetricNamespace
}

checkAlarm(metricFilter, resourceAlarm) = true {
    checkSNS(resourceAlarm.AlarmActions[_].Ref)
}

checkSNS(alarmRef) = true {
    resourceSNS := input.document[i].Resources
    some nameSNS
    resourceSNS[nameSNS].Type == "AWS::SNS::Topic"
    alarmRef != nameSNS
}

contains (array, string) = true {
	array[a] == string[b]
}
