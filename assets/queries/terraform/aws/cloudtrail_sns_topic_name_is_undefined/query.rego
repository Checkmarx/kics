package Cx

CxPolicy [ result ] {
  cloudtrail := input.document[i].resource.aws_cloudtrail[name]
  
  isDefined(cloudtrail)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudtrail[%s]", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("'aws_cloudtrail[%s].sns_topic_name' is set and is not null", [name]),
                "keyActualValue": 	sprintf("'aws_cloudtrail[%s].sns_topic_name' is undefined or null", [name])
              }
}

isDefined(resource) = true {
  object.get(resource,"sns_topic_name","undefined") == "undefined"
}

isDefined(resource) = true {
  resource.sns_topic_name == null
}