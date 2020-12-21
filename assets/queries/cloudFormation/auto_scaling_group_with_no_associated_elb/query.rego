package Cx

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
    resource.Type == "AWS::AutoScaling::AutoScalingGroup"
    object.get(resource.Properties, "LoadBalancerNames", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties",  [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancerNames' is defined", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.LoadBalancerNames' is not defined", [name]),
              }
}

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
    resource.Type == "AWS::AutoScaling::AutoScalingGroup"
    resource.Properties.LoadBalancerNames == null

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.LoadBalancerNames",  [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancerNames' is not null", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.LoadBalancerNames' is null", [name]),
              }
}

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
    resource.Type == "AWS::AutoScaling::AutoScalingGroup"
    elbs := resource.Properties.LoadBalancerNames
    check_size(elbs)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.LoadBalancerNames",  [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancerNames' is not empty", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.LoadBalancerNames' is empty", [name]),
              }
}

check_size(array) {
	is_array(array)
    count(array) == 0
}