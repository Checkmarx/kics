package Cx

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_config_configuration_aggregator[name]
	
	resource[type].all_regions != true    
    
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_config_configuration_aggregator[%s].%s.all_regions", [name, type]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'aws_db_instance[%s].[%s].all_regions' is true", [name, type]),
                "keyActualValue": sprintf("'aws_db_instance[%s].[%s].all_regions' is false", [name, type])
              }
}

