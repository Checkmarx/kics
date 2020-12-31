package Cx

CxPolicy [ result ] {

    resourceSNS := input.document[i].Resources
    some nameSNS
    resourceSNS[nameSNS].Type == "AWS::SNS::Topic"

    not resourceSNS[nameSNS].Properties.Subscription

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	     sprintf("Resources.%s.Properties.AlarmActions.Ref", [nameSNS]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue":  sprintf("'Resources.%s.Properties.Subscription' is setted)", [nameSNS]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.Subscription' is not setted)", [nameSNS]),
            }
}


