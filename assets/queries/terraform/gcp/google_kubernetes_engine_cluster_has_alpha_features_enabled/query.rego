package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.google_container_cluster[name]

    resource.enable_kubernetes_alpha == true

    result := {
        "documentId": input.document[i].id,
        "resourceType": "google_container_cluster",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("google_container_cluster[%s].enable_kubernetes_alpha", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'enable_kubernetes_alpha' should only be defined to 'false'",
        "keyActualValue": "'enable_kubernetes_alpha' is defined to 'true'",
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "enable_kubernetes_alpha"], []),
        "remediation": json.marshal({
    		"before": "true",
    		"after": "false"
    	}),
    	"remediationType": "replacement",
    }
}
