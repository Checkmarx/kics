package Cx

CxPolicy [ result ] {
   spec := input.document[i].spec 
   drop := spec.containers[c].securityContext.capabilities.drop
   not drop[0] == "ALL" 
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d].security_context.capabilities.drop", [c]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("All spec.containers[%d].security_context.capabilities must be dropped", [c]),
                "keyActualValue": 	sprintf("Are not being spec.containers[%d].security_context.capabilities dropped", [c])
              }
}

CxPolicy [ result ] {
   spec := input.document[i].spec
   exists_containers := object.get(spec, "containers", "undefined") != "undefined"
   not exists_containers
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "spec",
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": "spec.containers are defined",
                "keyActualValue": 	"spec.containers are undefined"
              }
}

CxPolicy [ result ] {
   spec := input.document[i].spec
   exists_containers := object.get(spec, "containers", "undefined") != "undefined"
   exists_containers
   
   containers := spec.containers
   exists_security_context := object.get(containers[c], "securityContext", "undefined") != "undefined"
   not exists_security_context
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d]", [c]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("spec.containers[%d].securityContext is defined", [c]),
                "keyActualValue": 	sprintf("spec.containers[%d].securityContext is undefined", [c])
              }
}

CxPolicy [ result ] {
   spec := input.document[i].spec
   exists_containers := object.get(spec, "containers", "undefined") != "undefined"
   exists_containers
   
   containers := spec.containers
   exists_security_context := object.get(containers[c], "securityContext", "undefined") != "undefined"
   exists_security_context
  
   securityContext := spec.containers[c].securityContext
   exists_capabilities := object.get(securityContext, "capabilities", "undefined") != "undefined"
   not exists_capabilities
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d].securityContext", [c]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("spec.containers[%d].securityContext.capabilities is defined", [c]),
                "keyActualValue": 	sprintf("spec.containers[%d].securityContext.capabilities is undefined", [c])
              }
}

CxPolicy [ result ] {
   spec := input.document[i].spec
   exists_containers := object.get(spec, "containers", "undefined") != "undefined"
   exists_containers
   
   containers := spec.containers
   exists_security_context := object.get(containers[c], "securityContext", "undefined") != "undefined"
   exists_security_context
  
   securityContext := spec.containers[c].securityContext
   exists_capabilities := object.get(securityContext, "capabilities", "undefined") != "undefined"
   exists_capabilities
   
   capabilities := spec.containers[c].securityContext.capabilities
   exists_drop := object.get(capabilities, "drop", "undefined") != "undefined"
   not exists_drop 
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d].securityContext.capabilities", [c]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("spec.containers[%d].securityContext.capabilities.drop is defined", [c]),
                "keyActualValue": 	sprintf("spec.containers[%d].securityContext.capabilities.drop is undefined", [c])
              }
}