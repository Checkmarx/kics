package Cx

CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") == "Pod"

    spec := document.spec

    metadata := document.metadata
    result := checkRootParent(spec,"spec",metadata)
}

CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") == "CronJob"

    spec := document.spec.jobTemplate.spec.template.spec

    metadata := document.metadata
    result := checkRootParent(spec,"spec.jobTemplate.spec.template.spec",metadata)
}

CxPolicy [ result ] {
    document := input.document[i]
    object.get(document,"kind","undefined") != "Pod"
    object.get(document,"kind","undefined") != "CronJob"

    spec := document.spec.template.spec

    metadata := document.metadata
    result := checkRootParent(spec,"spec.template.spec",metadata)
}

checkRootParent(spec,path,metadata) = result {
  nonRootParent := object.get(spec.securityContext,"runAsNonRoot","undefined")
  is_boolean(nonRootParent)

  nonRootParent == true

  result := checkRootContainer(spec,path,metadata)

}

checkRootParent(spec,path,metadata) = result {
  nonRootParent := object.get(spec.securityContext,"runAsNonRoot","undefined")
  is_boolean(nonRootParent)

  nonRootParent == false

  userParent := object.get(spec.securityContext,"runAsUser","undefined")
  is_number(userParent)

  userParent > 0

  result := checkUserContainer(spec,path,metadata)
}

checkRootParent(spec,path,metadata) = result {
  object.get(spec.securityContext,"runAsNonRoot","undefined") == "undefined"
  object.get(spec.securityContext,"runAsUser","undefined") == "undefined"

  result := checkRootContainer(spec,path,metadata)
}

checkRootContainer(spec,path,metadata) = result {
  some j
    container := spec.containers[j]
    not container.securityContext.runAsNonRoot
    uid := container.securityContext.runAsUser
    to_number(uid) <= 0
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s.containers",[path]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'%s.containers[%d].securityContext.runAsUser' is higher than 0 and/or 'runAsNonRoot' is true",[path,j]),
                "keyActualValue": 	sprintf("'%s.containers[%d].securityContext.runAsUser' is 0 and 'runAsNonRoot' is not set to true",[path,j]),
              }
}

checkRootContainer(spec,path,metadata) = result {
  some j
    container := spec.containers[j]
    not container.securityContext.runAsNonRoot
    object.get(container.securityContext,"runAsUser","undefined") == "undefined"
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.%s.containers",[metadata.name,path]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'%s.containers[%d].securityContext.runAsUser' is set to higher than 0 and/or 'runAsNonRoot' is true",[path,j]),
                "keyActualValue": 	sprintf("'%s.containers[%d].securityContext.runAsUser' is 0 and 'runAsNonRoot' is not set to true",[path,j]),
              }
}

checkUserContainer(spec,path,metadata) = result {
  some j
    container := spec.containers[j]
    uid := container.securityContext.runAsUser
    to_number(uid) <= 0
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.%s.containers",[metadata.name,path]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'%s.containers[%d].securityContext.runAsUser' is higher than 0 and/or 'runAsNonRoot' is true",[path,j]),
                "keyActualValue": 	sprintf("'%s.containers[%d].securityContext.runAsUser' is 0 and 'runAsNonRoot' is not set to true",[path,j]),
              }
}

checkUserContainer(spec,path,metadata) = result {
  some j
    container := spec.containers[j]
    not container.securityContext.runAsNonRoot
    object.get(container.securityContext,"runAsUser","undefined") == "undefined"
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.%s.containers",[metadata.name,path]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'%s.containers[%d].securityContext.runAsUser' is set to higher than 0 and/or 'runAsNonRoot' is true",[path,j]),
                "keyActualValue": 	sprintf("'%s.containers[%d].securityContext.runAsUser' is 0 and 'runAsNonRoot' is not set to true",[path,j]),
              }
}
