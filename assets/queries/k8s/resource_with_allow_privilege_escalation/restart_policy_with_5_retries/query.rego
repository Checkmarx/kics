package Cx

CxPolicy [ result ] {
   services := input.document[i].services[name] 
   restart_policy := services.deploy.restart_policy
   restart_policy.condition != "on-failure:5"
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("services[%s].deploy.restart_policy.condition", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("services[%s].deploy.restart_policy.condition", [name]),
                "keyActualValue": 	sprintf("services[%s].deploy.restart_policy.condition", [name])
              }
}