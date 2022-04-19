package Cx

CxPolicy[result] {
	resourceSNS := input.document[i].Resources
	some nameSNS
	resourceSNS[nameSNS].Type == "AWS::SNS::Topic"

	not resourceSNS[nameSNS].Properties.Subscription
	not has_aws_SNS_Sub(input,nameSNS)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [nameSNS]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Subscription' is set", [nameSNS]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Subscription' is not set", [nameSNS]),
	}
}

has_aws_SNS_Sub(input_document, name_SNS){
	resourceSNS := input_document.document[i].Resources
	resourceSNS[j].Type == "AWS::SNS::Subscription"
	resourceSNS[j].Properties.TopicArn.Ref == name_SNS
}
