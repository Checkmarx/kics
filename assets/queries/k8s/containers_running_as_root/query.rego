package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

types := {"initContainers", "containers"}

# if the node is Pod type
CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"

	spec := document.spec

	metadata := document.metadata
	result := checkRootParent(spec.securityContext, types[x], spec[types[x]][_],"spec", metadata,input.document[i].id)
}

# if the node is CronJob type
CxPolicy[result] {
	document := input.document[i]
	document.kind == "CronJob"

	spec := document.spec.jobTemplate.spec.template.spec

	metadata := document.metadata
	result := checkRootParent(spec.securityContext, types[x], spec[types[x]][_], "spec.jobTemplate.spec.template.spec", metadata,input.document[i].id)
}

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
	listKinds := ["Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "Service", "Secret", "ServiceAccount", "Role", "RoleBinding", "ConfigMap", "Ingress"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec.template.spec

	metadata := document.metadata
	result := checkRootParent(spec.securityContext, types[x], spec[types[x]][_], "spec.template.spec", metadata,input.document[i].id)
}

#if pod runAsNonRoot==true and container runAsNonRoot==true (container not runs as root)
#if pod runAsNonRoot==true and container runAsNonRoot==false 
							#if	container runAsUser>0 (container not runs as root)
							#if container runAsUser<=0 (container runs as root)
checkRootParent(rootSecurityContext, containerType, container, path, metadata,id) = result {
	nonRootParent := object.get(rootSecurityContext, "runAsNonRoot", "undefined")
	is_boolean(nonRootParent)

	nonRootParent == true

	result := checkRootContainer(rootSecurityContext, containerType, container, path, metadata,id)
}

#if pod runAsNonRoot==false and pod runAsUser>0
	#if container runAsUser>0
		#if container runAsNonRoot==false (container runs as non root)
		#if container runAsNonRoot==true (container runs as non root)
	#if container runAsUser<=0
		#if container runAsNonRoot==false (container runs as root)
		#if container runAsNonRoot==true (container runs as root)
checkRootParent(rootSecurityContext, containerType, container, path, metadata,id) = result {
	nonRootParent := object.get(rootSecurityContext, "runAsNonRoot", "undefined")
	is_boolean(nonRootParent)

	nonRootParent == false

	userParent := object.get(rootSecurityContext, "runAsUser", "undefined")
	is_number(userParent)

	userParent > 0

	result := checkUserContainer(rootSecurityContext, containerType, container, path, metadata,id)
}
#if pod runAsNonRoot==false and pod runAsUser<=0
	#if container runAsUser>0
		#if container runAsNonRoot==false (container runs as non root)
		#if container runAsNonRoot==true (container runs as non root)
	#if container runAsUser<=0
		#if container runAsNonRoot==false (container runs as root)
		#if container runAsNonRoot==true (container runs as non root)
checkRootParent(rootSecurityContext, containerType, container, path, metadata,id) = result {
	nonRootParent := object.get(rootSecurityContext, "runAsNonRoot", "undefined")
	is_boolean(nonRootParent)

	nonRootParent == false

	userParent := object.get(rootSecurityContext, "runAsUser", "undefined")
	is_number(userParent)

	userParent <= 0

	result := checkRootContainer(rootSecurityContext, containerType, container, path, metadata,id)
}


checkRootParent(rootSecurityContext, containerType, container, path, metadata,id) = result {
	not common_lib.valid_key(rootSecurityContext, "runAsNonRoot")
	not common_lib.valid_key(rootSecurityContext, "runAsUser")

	result := checkRootContainer(rootSecurityContext, containerType, container, path, metadata,id)
}

checkRootContainer(rootSecurityContext, containerType, container, path, metadata,id) = result {
	
	not container.securityContext.runAsNonRoot
	uid := container.securityContext.runAsUser
	to_number(uid) <= 0

	result := {
		"documentId": id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.%s", [metadata.name, path, containerType, container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.%s.securityContext.runAsUser' is higher than 0 and/or 'runAsNonRoot' is true", [path, containerType]),
		"keyActualValue": sprintf("'%s.%s.securityContext.runAsUser' is 0 and 'runAsNonRoot' is not set to true", [path, containerType]),
	}
}

checkRootContainer(rootSecurityContext, containerType, container, path, metadata,id) = result {

	not container.securityContext.runAsNonRoot
	not common_lib.valid_key(container.securityContext, "runAsUser")

	result := {
		"documentId": id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.{{%s}}.securityContext", [metadata.name, path, containerType, container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s.%s.securityContext.runAsUser' is defined", [path, containerType]),
		"keyActualValue": sprintf("'%s.%s.securityContext.runAsUser' is undefined", [path, containerType]),
	}
}

checkUserContainer(rootSecurityContext, containerType, container, path, metadata,id) = result {
	uid := container.securityContext.runAsUser
	to_number(uid) <= 0

	result := {
		"documentId": id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.%s", [metadata.name, path, containerType, container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.%s.securityContext.runAsUser' is higher than 0 and/or 'runAsNonRoot' is true", [path, containerType]),
		"keyActualValue": sprintf("'%s.%s.securityContext.runAsUser' is 0 and 'runAsNonRoot' is not set to true", [path, containerType]),
	}
}

checkUserContainer(rootSecurityContext, containerType, container, path, metadata,id) = result {
	not container.securityContext.runAsNonRoot
	not common_lib.valid_key(container.securityContext, "runAsUser")

	result := {
		"documentId": id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.{{%s}}.securityContext", [metadata.name, path, containerType, container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s.%s.securityContext.runAsUser' is defined", [path, containerType]),
		"keyActualValue": sprintf("'%s.%s.securityContext.runAsUser' is undefined", [path, containerType]),
	}
	
}
