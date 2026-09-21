package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    # Cases of "SNS Topic" or "SQS Queue" or "Lambda Function" with aws_s3_bucket_notification undefined
    s3 := input.document[i].resource[type][name]
    types := ["aws_sns_topic","aws_sqs_queue","aws_lambda_function"]
    type == types[_]

    not common_lib.valid_key(input.document[i].resource, "aws_s3_bucket_notification")  

    result := {
        "documentId": input.document[i].id,
        "resourceType": type,
		"resourceName": tf_lib.get_specific_resource_name(s3, "aws_s3_bucket_notification", type),
        "searchKey": sprintf("%s[%s]",[type,name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'aws_s3_bucket_notification' should be defined and not null",
        "keyActualValue": "'aws_s3_bucket_notification' is undefined or null",
        "searchLine": common_lib.build_search_line(["resource", type, name], []),
    }
}



CxPolicy[result] {
    # Cases of "SNS Topic" or "SQS Queue" or "Lambda Function" not referenced in aws_s3_bucket_notification
    s3 := input.document[i].resource[type][name]
    types := ["aws_sns_topic","aws_sqs_queue","aws_lambda_function"]
    type == types[_]

    common_lib.valid_key(input.document[i].resource, "aws_s3_bucket_notification")
    notification_bucket = input.document[i].resource.aws_s3_bucket_notification[_]

    not is_valid_reference(type,name,notification_bucket)

    result := {
        "documentId": input.document[i].id,
        "resourceType": type,
		"resourceName": tf_lib.get_specific_resource_name(s3, "aws_s3_bucket_notification", name),
        "searchKey": sprintf("%s[%s]",[type,name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("%s.%s should be evoked in aws_s3_bucket_notification ", [type,name]),
        "keyActualValue": sprintf("%s.%s is not properly evoked in aws_s3_bucket_notification ", [type,name]),
        "searchLine": common_lib.build_search_line(["resource", type, name], []),
    }
}



is_valid_reference(type,name,notification_bucket) = true {
    type == "aws_sns_topic"
    is_array(notification_bucket.topic)
    contains(split(notification_bucket.topic[i1].topic_arn,".")[0],type)
    split(notification_bucket.topic[i1].topic_arn,".")[1] == name
} else = true {
    type == "aws_sns_topic"
    not is_array(notification_bucket.topic)
    contains(split(notification_bucket.topic.topic_arn,".")[0],type)
    split(notification_bucket.topic.topic_arn,".")[1] == name
} else = true {
    type == "aws_sqs_queue" 
    is_array(notification_bucket.queue)
    contains(split(notification_bucket.queue[i2].queue_arn,".")[0],type)
    split(notification_bucket.queue[i2].queue_arn,".")[1] == name
} else = true {
    type == "aws_sqs_queue" 
    not is_array(notification_bucket.queue)
    contains(split(notification_bucket.queue.queue_arn,".")[0],type)
    split(notification_bucket.queue.queue_arn,".")[1] == name
} else = true {
    type == "aws_lambda_function"
    is_array(notification_bucket.lambda_function)
    contains(split(notification_bucket.lambda_function[i3].lambda_function_arn ,".")[0],type)
    split(notification_bucket.lambda_function[i3].lambda_function_arn ,".")[1] == name
} else = true {
    type == "aws_lambda_function"
    not is_array(notification_bucket.lambda_function)
    contains(split(notification_bucket.lambda_function.lambda_function_arn ,".")[0],type)
    split(notification_bucket.lambda_function.lambda_function_arn ,".")[1] == name
} else = false
