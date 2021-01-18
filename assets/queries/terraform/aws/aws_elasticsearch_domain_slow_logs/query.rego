package Cx

CxPolicy [ result ] {
  awsElasticsearchDomain := input.document[i].resource.aws_elasticsearch_domain[name]
  awsElasticsearchDomain.log_publishing_options.enabled == false
 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_elasticsearch_domain[%s].log_publishing_options.enabled", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "'log_publishing_options.enabled' is true",
                "keyActualValue": 	"'log_publishing_options.enabled' is false"
              }
}

CxPolicy [ result ] {
  awsElasticsearchDomain := input.document[i].resource.aws_elasticsearch_domain[name]
  logType := awsElasticsearchDomain.log_publishing_options.log_type
  not contains(["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS"], logType) 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_elasticsearch_domain[%s].log_publishing_options.log_type", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "'log_publishing_options.log_type' is not INDEX_SLOW_LOGS or SEARCH_SLOW_LOGS  ",
                "keyActualValue": 	"'log_publishing_options.enabled' is ES_APPLICATION_LOGS or AUDIT_LOGS"
              }
}

contains(array, elem) = true {
  array[_] == elem
} else = false { true }