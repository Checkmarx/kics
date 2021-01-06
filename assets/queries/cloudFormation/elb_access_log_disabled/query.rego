package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
  prop := resource.Properties
  checkALP(prop)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties", [name]),
                "issueType":		"MissingAttribute",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": sprintf("'Resources.%s.Properties.AccessLoggingPolicy' exists", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.AccessLoggingPolicy' is missing", [name])
              }
}

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
  prop := resource.Properties
  checkALPAttr(prop)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.AccessLoggingPolicy.Enabled", [name]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": sprintf("'Resources.%s.Properties.AccessLoggingPolicy.Enabled' is true", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.AccessLoggingPolicy.Enabled' is false", [name])
              }
}

checkALP(prop){
	object.get(prop, "AccessLoggingPolicy", "not found") == "not found"
}

checkALPAttr(prop) {
    prop.AccessLoggingPolicy.Enabled == false
}