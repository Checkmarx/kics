package Cx

CxPolicy [ result ] {
  awsElasticsearchDomain := input.document[i].resource.aws_elasticsearch_domain[name]
  logPubOpt := awsElasticsearchDomain.log_publishing_options.enabled
  logPubOpt == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_elasticsearch_domain.example[%s].enabled", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "'log_publishing_options.enabled' is true",
                "keyActualValue": 	"'log_publishing_options.enabled' is false"
              }
}