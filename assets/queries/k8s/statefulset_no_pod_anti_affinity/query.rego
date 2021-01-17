package Cx

CxPolicy [ result ] {
    statefulset := input.document[i]
    object.get(statefulset,"kind","undefined") == "StatefulSet"
    
    metadata := statefulset.metadata
    
    to_number(statefulset.spec.replicas) > 2

    object.get(statefulset.spec.template.spec,"affinity","undefined") == "undefined"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.template.spec",[metadata.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'spec.template.spec.affinity' is set",
                "keyActualValue": "'spec.template.spec.affinity' is undefined"
              }
}

CxPolicy [ result ] {
    statefulset := input.document[i]
    object.get(statefulset,"kind","undefined") == "StatefulSet"

    to_number(statefulset.spec.replicas) > 2

    affinity := statefulset.spec.template.spec.affinity
    object.get(affinity,"podAntiAffinity","undefined") == "undefined"
    
    metadata := statefulset.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.template.spec.affinity",[metadata.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'spec.template.spec.affinity.podAntiAffinity' is set",
                "keyActualValue": "'spec.template.spec.affinity.podAntiAffinity' is undefined"
              }
}

CxPolicy [ result ] {
    statefulset := input.document[i]
    object.get(statefulset,"kind","undefined") == "StatefulSet"

    to_number(statefulset.spec.replicas) > 2

    affinity := statefulset.spec.template.spec.affinity
    object.get(affinity,"podAntiAffinity","undefined") == "undefined"
    
    metadata := statefulset.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.template.spec.affinity",[metadata.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'spec.template.spec.affinity.podAntiAffinity' is set",
                "keyActualValue": "'spec.template.spec.affinity.podAntiAffinity' is undefined"
              }
}

CxPolicy [ result ] {
    statefulset := input.document[i]
    object.get(statefulset,"kind","undefined") == "StatefulSet"

    to_number(statefulset.spec.replicas) > 2

    affinity := statefulset.spec.template.spec.affinity
    object.get(affinity,"podAntiAffinity","undefined") != "undefined"
    
    podAntiAffinity:= affinity.podAntiAffinity

    object.get(podAntiAffinity,"preferredDuringSchedulingIgnoredDuringExecution","undefined") == "undefined"
    object.get(podAntiAffinity,"requiredDuringSchedulingIgnoredDuringExecution","undefined") == "undefined"


    metadata := statefulset.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.template.spec.affinity.podAntiAffinity",[metadata.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution' and/or 'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution' is set",
                "keyActualValue": "'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution' and 'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution' is undefined"
              }
}

CxPolicy [ result ] {
    statefulset := input.document[i]
    object.get(statefulset,"kind","undefined") == "StatefulSet"

    to_number(statefulset.spec.replicas) > 2

    affinity := statefulset.spec.template.spec.affinity
    object.get(affinity,"podAntiAffinity","undefined") != "undefined"
    
    podAntiAffinity:= affinity.podAntiAffinity

    object.get(podAntiAffinity,"preferredDuringSchedulingIgnoredDuringExecution","undefined") != "undefined"

    pref := podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[j]

    object.get(pref.podAffinityTerm,"topologyKey","undefined") != "kubernetes.io/hostname"

    metadata := statefulset.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution.podAffinityTerm",[metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[%s].podAffinityTerm.topologyKey' is set and is 'kubernetes.io/hostname'",[j]),
                "keyActualValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[%s].podAffinityTerm.topologyKey' is invalid or undefined",[j])
              }
}

CxPolicy [ result ] {
    statefulset := input.document[i]
    object.get(statefulset,"kind","undefined") == "StatefulSet"

    to_number(statefulset.spec.replicas) > 2

    affinity := statefulset.spec.template.spec.affinity
    object.get(affinity,"podAntiAffinity","undefined") != "undefined"
    
    podAntiAffinity:= affinity.podAntiAffinity

    object.get(podAntiAffinity,"preferredDuringSchedulingIgnoredDuringExecution","undefined") != "undefined"

    pref := podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[j]

    object.get(pref.podAffinityTerm,"topologyKey","undefined") == "kubernetes.io/hostname"

    templateLabels := statefulset.spec.template.metadata.labels 
    selectorLabels := pref.podAffinityTerm.labelSelector.matchLabels

    matchLabels(templateLabels,selectorLabels) == false

    metadata := statefulset.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution.podAffinityTerm.labelSelector.matchLabels",[metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[%d].podAffinityTerm.labelSelector.matchLabels' match any label on template metadata",[j]),
                "keyActualValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[%d].podAffinityTerm.labelSelector.matchLabels' don't match any label on template metadata",[j])
              }
}

CxPolicy [ result ] {
    statefulset := input.document[i]
    object.get(statefulset,"kind","undefined") == "StatefulSet"

    to_number(statefulset.spec.replicas) > 2

    affinity := statefulset.spec.template.spec.affinity
    object.get(affinity,"podAntiAffinity","undefined") != "undefined"
    
    podAntiAffinity:= affinity.podAntiAffinity

    object.get(podAntiAffinity,"requiredDuringSchedulingIgnoredDuringExecution","undefined") != "undefined"

    pref := podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[j]

    object.get(pref,"topologyKey","undefined") != "kubernetes.io/hostname"

    metadata := statefulset.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution",[metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[%d].topologyKey' is set and is 'kubernetes.io/hostname'",[j]),
                "keyActualValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[%d].topologyKey' is invalid or undefined",[j])
              }
}

CxPolicy [ result ] {
    statefulset := input.document[i]
    object.get(statefulset,"kind","undefined") == "StatefulSet"

    to_number(statefulset.spec.replicas) > 2

    affinity := statefulset.spec.template.spec.affinity
    object.get(affinity,"podAntiAffinity","undefined") != "undefined"
    
    podAntiAffinity:= affinity.podAntiAffinity

    object.get(podAntiAffinity,"requiredDuringSchedulingIgnoredDuringExecution","undefined") != "undefined"

    pref := podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[j]

    object.get(pref,"topologyKey","undefined") == "kubernetes.io/hostname"

    templateLabels := statefulset.spec.template.metadata.labels 
    selectorLabels := pref.labelSelector.matchLabels

    matchLabels(templateLabels,selectorLabels) == false

    metadata := statefulset.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution.labelSelector.matchLabels",[metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[%d].labelSelector.matchLabels' match any label on template metadata",[j]),
                "keyActualValue": sprintf("'spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[%d].labelSelector.matchLabels' don't match any label on template metadata",[j])
              }
}

matchLabels(templateLabels,selectorLabels) = true {
  some Key
    templateLabels[Key] == selectorLabels[Key]
} else = false {
  true
}