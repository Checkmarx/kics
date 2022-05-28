package Cx  

import data.generic.common as common_lib

CxPolicy[result] {
	statefulset := input.document[i]
	statefulset.kind == "StatefulSet"

	count({x | 	resource := input.document[x];
    			resource.kind == "Service"; 
            	resource.spec.clusterIP == "None"; 
            	statefulset.metadata.namespace == resource.metadata.namespace; 
            	statefulset.spec.serviceName == resource.metadata.name; 
            	match_labels( resource.spec.selector, statefulset.spec.template.metadata.labels)
            	}) == 0

	metadata := statefulset.metadata.name

	result := {
		"documentId": input.document[i].id,
		"resourceType": statefulset.kind,
		"resourceName": metadata,
		"searchKey": sprintf("metadata.name=%s.spec.serviceName", [metadata]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.serviceName should refer to a Headless Service", [metadata]),
		"keyActualValue": sprintf("metadata.name=%s.spec.serviceName doesn't refers to a Headless Service", [metadata]),
		"searchLine": common_lib.build_search_line(["spec", "serviceName"], [])
	}
}

match_labels(serviceLabels, statefulsetLabels) {
    count({x | label := serviceLabels[x]; label == statefulsetLabels[x]}) == count(serviceLabels)
}
