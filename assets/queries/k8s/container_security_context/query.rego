package Cx

CxPolicy [ result ] {
    document := input.document[i]
    specInfo := getSpecInfo(document)
    
    spec := document.spec
    
    document.kind == "Pod"
    not spec.securityContext

	result := {
                "documentId": 		  input.document[i].id,
                "issueType":		  "MissingAttribute",
                "searchKey": 	      sprintf("%s", [specInfo.path]),
                "keyExpectedValue":   sprintf("Pod has a security context applied in document[%d]",[i]),
                "keyActualValue": 	  sprintf("Pod has not a security context applied in document[%d]",[i])
              }
}


CxPolicy [ result ] {
    document := input.document[i]
    specInfo := getSpecInfo(document)

    containers := document.spec.containers
    
    lengthContainers := count(containers)
    
    count({x | containers[x]; object.get(containers[x], "securityContext", "undefined") != "undefined" }) != lengthContainers


	result := {
                "documentId": 		  input.document[i].id,
                "issueType":		  "MissingAttribute",
                "searchKey": 	      sprintf("%s.containers", [specInfo.path]),
                "keyExpectedValue":   sprintf("All containers have a security context applied in document[%d]",[i]),
                "keyActualValue": 	  sprintf("All or some containers have not a security context applied in document[%d]",[i])
              }
}

getSpecInfo(document) = specInfo {
    templates := {"job_template", "jobTemplate"}
    spec := document.spec[templates[t]].spec.template.spec
    specInfo := {"spec": spec, "path": sprintf("spec.%s.spec.template.spec", [templates[t]])}
} else = specInfo {
    spec := document.spec.template.spec
    specInfo := {"spec": spec, "path": "spec.template.spec"}
} else = specInfo {
    spec := document.spec
    specInfo := {"spec": spec, "path": "spec"}
} 