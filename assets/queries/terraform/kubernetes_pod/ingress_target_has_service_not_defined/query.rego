package Cx

CxPolicy [ result ] {
  resourcePod := input.document[i].resource.kubernetes_pod[namePod]
  ingressPod := resourcePod.metadata.labels.app

  resourceIngress := input.document[i].resource.kubernetes_ingress[nameIngress]
  ingress:= resourceIngress.spec.backend.service_name 
  
  not CheckIngressApp(ingressPod, ingress)
  

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("kubernetes_pod[%s].metadata.labels.app", [namePod]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("kubernetes_pod[%s].metadata.labels.app is defined in kubernetes_ingress[%s]", [namePod, ingress]),
                "keyActualValue": 	sprintf("kubernetes_pod[%s].metadata.labels.app is undefined in kubernetes_ingress[%s]", [namePod, ingress])
            }
}

CxPolicy [ result ] {
  resourcePod := input.document[i].resource.kubernetes_pod[namePod]
  ingressPod := resourcePod.metadata.labels.app

  resourceIngress := input.document[i].resource.kubernetes_ingress[nameIngress]
  ingress:= resourceIngress.spec.rule.http.path.backend.service_name
  
  not CheckIngressApp(ingressPod, ingress)
  

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("kubernetes_pod[%s].metadata.labels.app", [namePod]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("kubernetes_pod[%s].metadata.labels.app is defined in kubernetes_ingress[%s]", [namePod, ingress]),
                "keyActualValue": 	sprintf("kubernetes_pod[%s].metadata.labels.app is undefined in kubernetes_ingress[%s]", [namePod, ingress])
            }
}


CheckIngressApp(ingressPod, ingress) = true {
	ingressPod == ingress
}