package Cx

CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") == "Pod"

    spec := document.spec

    isLowUID(spec)

    metadata := document.metadata
    result := checkContainersOverride(spec,"",metadata, input.document[i].id)
}

CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") == "Pod"

    spec := document.spec

    isSetUID(spec) != true

    metadata := document.metadata
    result := checkContainersSet(spec,"",metadata, input.document[i].id)
}

CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") == "CronJob"

    spec := document.spec.jobTemplate.spec.template.spec

    isLowUID(spec)

    metadata := document.metadata
    result := checkContainersOverride(spec,"spec.jobTemplate.spec.template.",metadata, input.document[i].id)
}

CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") == "CronJob"

    spec := document.spec.jobTemplate.spec.template.spec

    isSetUID(spec) != true

    metadata := document.metadata
    result := checkContainersSet(spec,"spec.jobTemplate.spec.template.",metadata, input.document[i].id)
}
CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") != "Pod"
    object.get(document,"kind","undefined") != "CronJob"

    spec := document.spec.template.spec

    isSetUID(spec) != true

    metadata := document.metadata
    result := checkContainersSet(spec,"spec.template.",metadata, input.document[i].id)
}

CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") != "Pod"
    object.get(document,"kind","undefined") != "CronJob"

    spec := document.spec.template.spec

    isLowUID(spec)

    metadata := document.metadata
    result := checkContainersOverride(spec,"spec.template.",metadata, input.document[i].id)
}

CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") != "Pod"
    object.get(document,"kind","undefined") != "CronJob" 

    spec := document.spec.template.spec

    isSetUID(spec) != true

    metadata := document.metadata
    result := checkContainersSet(spec,"spec.template.",metadata, input.document[i].id)
}

#if there are no containers to override low UID setting
checkContainersOverride(spec,path,metadata, id) = result {
    object.get(spec,"containers","undefined") == "undefined"
    
    result := {
                "documentId": 		id,
                "searchKey": 	    sprintf("metadata.name=%s.%sspec.securityContext.runAsUser",[metadata.name,path]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'%sspec.securityContext.runAsUser' is higher or equal to 10000",[path]),
                "keyActualValue": 	sprintf("'%sspec.securityContext.runAsUser' is less than 10000",[path]),
              }
}

#if there are containers and one of them has also low UID setting
checkContainersOverride(spec,path,metadata, id) = result {
    containers := object.get(spec,"containers","undefined")
    containers != "undefined"

    some j
      isLowUID(containers[j])
      result := {
                  "documentId": 		id,
                  "searchKey": 	    sprintf("metadata.name=%s.%sspec.containers",[metadata.name,path]),
                  "issueType":		"IncorrectValue",
                  "keyExpectedValue": sprintf("'%sspec.containers[%d].securityContext.runAsUser' is higher or equal to 10000",[path,j]),
                  "keyActualValue": 	sprintf("'%sspec.containers[%d].securityContext.runAsUser' is less than 10000",[path,j]),
                }
}

#if there are containers and one of them doesn't override low UID setting
checkContainersSet(spec,path,metadata, id) = result {
    containers := object.get(spec,"containers","undefined")
    containers != "undefined"
    some j
      isSetUID(containers[j]) != true
      result := {
                  "documentId": 		id,
                  "searchKey": 	    sprintf("metadata.name=%s.%sspec.containers",[metadata.name,path]),
                  "issueType":		"MissingAttribute",
                  "keyExpectedValue": sprintf("'%sspec.containers[%d].securityContext.runAsUser' is set and higher or equal to 10000",[path,j]),
                  "keyActualValue": 	sprintf("'$sspec.containers[%d].securityContext.runAsUser' is undefined",[path,j]),
                }
}

#if there are containers and one of them doesn't override low UID setting
checkContainersSet(spec,path,metadata, id) = result {
    containers := object.get(spec,"containers","undefined")
    containers != "undefined"

    some j
      isSetUID(containers[j]) != true
      result := {
                  "documentId": 		id,
                  "searchKey": 	    sprintf("metadata.name=%s.%sspec.containers",[metadata.name,path]),
                  "issueType":		"MissingAttribute",
                  "keyExpectedValue": sprintf("'%sspec.containers[%d].securityContext.runAsUser' is set and higher or equal to 10000",[path,j]),
                  "keyActualValue": 	sprintf("'%sspec.containers[%d].securityContext.runAsUser' is undefined",[path,j]),
                }
}

isLowUID(spec) {
  to_number(spec.securityContext.runAsUser) < 10000  
}

isSetUID(spec) = true {
  object.get(spec.securityContext,"runAsUser","undefined") != "undefined"
}
