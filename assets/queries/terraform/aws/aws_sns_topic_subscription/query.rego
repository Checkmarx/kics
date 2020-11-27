package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource
  awsSnsTopic := resource.aws_sns_topic[name_sns_topic]
  awsSnsTopicArn := sprintf("${aws_sns_topic.%s.arn}", [name_sns_topic])
  awsSubTopic := resource.aws_sns_topic_subscription
  contains(awsSubTopic,awsSnsTopicArn) == false

 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_sns_topic[%s]", [name_sns_topic]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("aws_sns_topic[%s] arn is the same as subscription arn", [name_sns_topic]),
				        "keyActualValue": sprintf("aws_sns_topic[%s] arn is not the same as subscription arn", [name_sns_topic]),
              }
}

contains(array, elem) = true {
  array[_].topic_arn == elem
} else = false { true }