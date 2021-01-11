package Cx

CxPolicy [ result ] {
    msk_cluster := input.document[i].resource.aws_msk_cluster[name]
    tech := msk_cluster.logging_info.broker_logs[instanceType]
    not tech.enabled
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf(getSearchKey(msk_cluster, instanceType), [name, instanceType]),
                "issueType":		  getIssueType(msk_cluster, instanceType),
                "keyExpectedValue": "'rule.logging_info.broker_logs.enabled' should be 'true' in every entry",
                "keyActualValue": 	sprintf("msk_cluster[%s].logging_info.broker_logs.%s.enabled is %s", [name, instanceType, getActualValue(msk_cluster, instanceType)])
              }
}

CxPolicy [ result ] {
    msk_cluster := input.document[i].resource.aws_msk_cluster[name]

    msk_cluster.logging_info
    
    not msk_cluster.logging_info.broker_logs["cloudwatch_logs"]
    not msk_cluster.logging_info.broker_logs["firehose"]
    not msk_cluster.logging_info.broker_logs["s3"]
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("msk_cluster[%s].logging_info.broker_logs", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "Should have at least one of the following keys: 'cloudwatch_logs', 'firehose' or 's3'",
                "keyActualValue": 	"'rule.logging_info.broker_logs.cloudwatch_logs', 'rule.logging_info.broker_logs.firehose' and 'rule.logging_info.broker_logs.s3' do not exists"
              }
}

CxPolicy [ result ] {
    msk_cluster := input.document[i].resource.aws_msk_cluster[name]
    not msk_cluster.logging_info
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("msk_cluster[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "Should exists 'rule.logging_info'",
                "keyActualValue": 	"'rule.logging_info' does not exists"
              }
}

getSearchKey(msk_cluster, instanceType) = "msk_cluster[%s].logging_info.broker_logs.%s.enabled" {
  _ = msk_cluster.logging_info.broker_logs[instanceType]["enabled"]
} else = "msk_cluster[%s].logging_info.broker_logs.%s" {
  true
}

getIssueType(msk_cluster, instanceType) = "IncorretValue" {
	_ = msk_cluster.logging_info.broker_logs[instanceType]["enabled"]
} else = "MissingAttribute" {
	true
}

getActualValue(msk_cluster, instanceType) = "false" {
	_ = msk_cluster.logging_info.broker_logs[instanceType]["enabled"]
} else = "missing" {
	true
}

