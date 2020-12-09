package Cx

CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") != "Job"
    object.get(document,"kind","undefined") != "CronJob"


    some j
      container := document.spec.containers[j]
      object.get(container,"readinessProbe","undefined") == "undefined"
    
    metadata := document.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.containers",[metadata.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'spec.containers[%d].readinessProbe' is set",[j]),
                "keyActualValue": sprintf("'spec.containers[%d].readinessProbe' is undefined",[j])
              }
}